import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/doctor_controller.dart';
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
  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    void logout() async {
      if (authNotifier.userType == UserType.patient) {
        await PatientController().logout(authNotifier);
      } else if (authNotifier.userType == UserType.doctor) {
        await DoctorController()
            .logout(authNotifier); // todo: implement doctor logout
      } else if (authNotifier.userType == UserType.nurse) {
        await NurseController().logout(authNotifier);
      }
      await LocalStorage.clearUser();
      if (context.mounted) {
        // ! ensure that the widget is mounted before navigating
        Navigator.pushNamed(context, '/login');
      }
    }

    if (authNotifier.appUser == null) {
      return const Scaffold(
        body: Text("APP user is null"),
      );
    } else {
      log((authNotifier.appUser!.imageUrl));
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
