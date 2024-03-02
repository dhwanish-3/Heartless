import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:heartless/backend/services/misc/connect_users.dart';
import 'package:heartless/main.dart';
import 'package:heartless/services/utils/qr_scanner.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  String qrCodeResult = "Not Yet Scanned";

  //! user here
  AppUser? user;
  // Function to scan the QR code
  Future<void> scanQRCode() async {
    QRScanner.scanQRCode().then((value) async {
      log(value);
      AppUser? user = await ConnectUsers.getUserDetails(value);
      setState(() {
        qrCodeResult = value;
        this.user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    // * addUser function
    Future<void> addUser() async {
      if (user != null) {
        // connent doctor and patient
        log(user!.userType.toString());
        log(authNotifier.userType.toString());
        if ((authNotifier.userType == UserType.doctor &&
            user!.userType == UserType.patient)) {
          await ConnectUsers.connectPatientAndDoctor(
              patientId: user!.uid, doctorId: authNotifier.appUser!.uid);
        } else if (authNotifier.userType == UserType.patient &&
            user!.userType == UserType.doctor) {
          await ConnectUsers.connectPatientAndDoctor(
              patientId: authNotifier.appUser!.uid, doctorId: user!.uid);
        }
        // connect nurse and patient
        else if (authNotifier.userType == UserType.nurse &&
            user!.userType == UserType.patient) {
          await ConnectUsers.connectNurseAndPatient(
              patientId: user!.uid, nurseId: authNotifier.appUser!.uid);
        } else if (authNotifier.userType == UserType.patient &&
            user!.userType == UserType.nurse) {
          await ConnectUsers.connectNurseAndPatient(
              patientId: authNotifier.appUser!.uid, nurseId: user!.uid);
        }
        // connect doctor and nurse
        else if (authNotifier.userType == UserType.doctor &&
            user!.userType == UserType.nurse) {
          await ConnectUsers.connectDoctorAndNurse(
              doctorId: authNotifier.appUser!.uid, nurseId: user!.uid);
        } else if (authNotifier.userType == UserType.nurse &&
            user!.userType == UserType.doctor) {
          await ConnectUsers.connectDoctorAndNurse(
              doctorId: user!.uid, nurseId: authNotifier.appUser!.uid);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR Code"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Message displayed over here
            const Text(
              "Result",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              qrCodeResult,
              style: const TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            if (user != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    user!.imageUrl,
                    height: 100,
                  ),
                  Text(
                    user!.name,
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              ElevatedButton(onPressed: addUser, child: const Text('Add User'))
            ],
            const SizedBox(
              height: 20.0,
            ),
            // Button to scan QR code
            ElevatedButton(
              onPressed: scanQRCode,
              // Button having rounded rectangle border
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
              ),
              child: const Text(
                "Open Scanner",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
