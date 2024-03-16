import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heartless/backend/controllers/auth_controller.dart';
import 'package:heartless/backend/controllers/connect_users_controller.dart';
import 'package:heartless/main.dart';
import 'package:heartless/pages/auth/scan_qr_page.dart';
import 'package:heartless/pages/chat/contacts_page.dart';
import 'package:heartless/pages/patient_management/patient_profile_page.dart';
import 'package:heartless/services/enums/user_type.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DummyHome extends StatefulWidget {
  const DummyHome({super.key});

  @override
  State<DummyHome> createState() => _DummyHomeState();
}

class _DummyHomeState extends State<DummyHome> {
  final AuthController _authController = AuthController();

  List<AppUser> users = []; // list of patients

  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    ConnectUsersController.getAllPatientsHandledByUser(
            authNotifier.appUser!.uid, authNotifier.appUser!.userType)
        .then((value) {
      setState(() {
        users = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    // ! logout function
    void logout() async {
      await _authController.logout(authNotifier);
      if (context.mounted) {
        // ! ensure that the widget is mounted before navigating
        Navigator.pushNamedAndRemoveUntil(
            context, '/loginOrSignup', (route) => false);
      }
    }

    if (authNotifier.appUser == null) {
      return const Scaffold(
        body: Text("APP user is null"),
      );
    } else {
      return WillPopScope(
        onWillPop: () async {
          final val = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  contentPadding: const EdgeInsets.all(25),
                  actionsPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  title: const Text('Alert'),
                  content: const Text('Do you want to Exit the App'),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('No')),
                    ElevatedButton(
                        onPressed: () {
                          SystemNavigator.pop();
                          // Navigator.of(context).pop(true);
                        },
                        child: const Text('Yes'))
                  ],
                );
              });
          if (val != null) {
            return Future.value(val);
          } else {
            return Future.value(false);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Dummy Home'),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome ${authNotifier.appUser!.name}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CachedNetworkImage(
                      imageUrl:
                          Uri.parse(authNotifier.appUser!.imageUrl).isAbsolute
                              ? authNotifier.appUser!.imageUrl
                              : 'https://via.placeholder.com/150',
                      height: 52,
                      width: 52,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      // todo: modify the error widget
                      errorWidget: (context, url, error) => Container(
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Theme.of(context).shadowColor,
                          ),
                          child: const Icon(
                            Icons.person_2_outlined,
                            color: Colors.black,
                            size: 30,
                          )),
                    ),
                  ),
                  Text(authNotifier.appUser!.name),
                  Text(authNotifier.appUser!.email),
                  Text(authNotifier.appUser!.uid),
                  QrImageView(
                      data: authNotifier.appUser!.uid,
                      size: 200,
                      backgroundColor: Colors.white,
                      errorStateBuilder: (cxt, err) {
                        return const Center(
                          child: Text("Uh oh! Something went wrong..."),
                        );
                      }),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const ScanQR()));
                      },
                      child: const Text('Scan QR')),
                  authNotifier.appUser!.userType != UserType.patient
                      ? Column(
                          children: [
                            const Text(
                                'List of patients (tap to view profile)'),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                itemCount: users.length,
                                itemBuilder: (BuildContext context, int index) {
                                  AppUser user = users[index];
                                  return ListTile(
                                    title: Text(user.name),
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(user.imageUrl),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PatientProfilePage(
                                                    patient: user,
                                                  )));
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ContactsPage()));
                      },
                      child: const Text('Chats')),
                  ElevatedButton(
                      onPressed: logout, child: const Text('Logout')),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
