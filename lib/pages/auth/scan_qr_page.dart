import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/connect_users_controller.dart';
import 'package:heartless/backend/services/misc/connect_users.dart';
import 'package:heartless/services/utils/qr_scanner.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:heartless/widgets/miscellaneous/right_trailing_button.dart';
import 'package:provider/provider.dart';

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
      value = "zYDOehue0sdbf5uKRUnHllCKqn83";
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
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);

    // * addUser function
    Future<void> addUser() async {
      if (user != null &&
          authNotifier.appUser!.uid != user!.uid &&
          authNotifier.appUser!.userType != user!.userType) {
        widgetNotifier.setLoading(true);
        await ConnectUsersController.connectUsers(authNotifier.appUser!, user!);
        widgetNotifier.setLoading(false);
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
              // Add user button if the user is not the same type
              user!.userType != authNotifier.appUser!.userType
                  ? GestureDetector(
                      onTap: addUser,
                      child: const RightButton(text: 'Add User'))
                  : Container()
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
