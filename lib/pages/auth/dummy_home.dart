import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/nurse_controller.dart';
import 'package:heartless/backend/controllers/patient_controller.dart';
import 'package:heartless/main.dart';
import 'package:heartless/pages/auth/scan_qr_page.dart';
import 'package:heartless/pages/chat/contacts_page.dart';
import 'package:heartless/services/local_storage/local_storage.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DummyHome extends StatefulWidget {
  const DummyHome({super.key});

  @override
  State<DummyHome> createState() => _DummyHomeState();
}

class _DummyHomeState extends State<DummyHome> {
  void logout() async {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    if (authNotifier.userType == UserType.patient) {
      await PatientController().logout(authNotifier);
    } else if (authNotifier.userType == UserType.doctor) {
      // await DoctorController().logout(authNotifier); // todo: implement doctor logout
    } else if (authNotifier.userType == UserType.nurse) {
      await NurseController().logout(authNotifier);
    }
    await LocalStorage.clearUser();
    if (context.mounted) {
      // ! ensure that the widget is mounted before navigating
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    if (authNotifier.appUser == null) {
      return const Scaffold(
        body: Text("APP user is null"),
      );
    } else {
      return Scaffold(
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
                Image.network(
                  authNotifier.appUser!.imageUrl,
                  height: 200,
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
                ElevatedButton(onPressed: logout, child: const Text('Logout')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ContactsPage()));
                    },
                    child: const Text('Chats')),
              ],
            ),
          ),
        ),
      );
    }
  }
}
