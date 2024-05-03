import 'package:flutter/material.dart';
import 'package:heartless/backend/services/misc/connect_users.dart';
import 'package:heartless/pages/profile/qr_result_page.dart';
import 'package:heartless/services/enums/user_type.dart';
import 'package:heartless/services/utils/qr_scanner.dart';
import 'package:heartless/services/utils/toast_message.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRPopupWidget extends StatefulWidget {
  final AppUser user;
  const QRPopupWidget({
    super.key,
    required this.user,
  });

  @override
  State<QRPopupWidget> createState() => _QRPopupWidgetState();
}

class _QRPopupWidgetState extends State<QRPopupWidget> {
  String qrCodeResult = "Not Yet Scanned";

  Future<void> scanQRCode(AuthNotifier authNotifier) async {
    QRScanner.scanQRCode().then((value) async {
      AppUser? user = await ConnectUsers.getUserDetails(value);
      qrCodeResult = value;
      ToastMessage Toast = ToastMessage();
      if (user == null) {
        Toast.showError("Qr Code does not belong to a valid user");
      } else if (authNotifier.appUser!.uid == user.uid) {
        Toast.showError("Can't add yourself");
      } else if (authNotifier.appUser!.userType == user.userType) {
        Toast.showError(
            "Can't add user who is a ${user.userType.capitalisedName}");
      } else {
        await Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (context) => QRResultPage(appUser: user),
          ),
        )
            .then((value) {
          Toast.showSuccess(
              "${user.userType.capitalisedName} added successfully");
        });
      }
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);

    return Center(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          // color: Theme.of(context).cardColor,
          color: Theme.of(context).secondaryHeaderColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).highlightColor,
              offset: const Offset(0, 0.5),
              blurRadius: 1,
              spreadRadius: 0,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    widget.user.imageUrl,
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  widget.user.name,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            QrImageView(
                data: widget.user.uid,
                size: 240,
                backgroundColor: Colors.white,
                errorStateBuilder: (cxt, err) {
                  return const Center(
                    child: Text("Uh oh! Something went wrong..."),
                  );
                }),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.mail,
                  size: 12,
                ),
                const SizedBox(width: 2),
                Text(
                  widget.user.email,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
                height: 50,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context).shadowColor,
                      width: 1,
                      style: BorderStyle.solid,
                    )),
                child: Material(
                  child: InkWell(
                    onTap: () {
                      scanQRCode(authNotifier);

                      //! mechanism to add the scanner user
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_scanner_rounded,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 5),
                        Text('Open Scanner',
                            style: TextStyle(
                              color: Theme.of(context).shadowColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
