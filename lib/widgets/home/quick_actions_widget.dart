import 'package:flutter/material.dart';
import 'package:heartless/backend/services/misc/connect_users.dart';
import 'package:heartless/pages/log/health_documents_page.dart';
import 'package:heartless/pages/profile/extended_timeline_page.dart';
import 'package:heartless/pages/profile/qr_result_page.dart';
import 'package:heartless/pages/schedule/create_task_page.dart';
import 'package:heartless/services/enums/user_type.dart';
import 'package:heartless/services/utils/qr_scanner.dart';
import 'package:heartless/services/utils/toast_message.dart';
import 'package:heartless/shared/models/app_user.dart';

class QuickActionsWidget extends StatelessWidget {
  final AppUser user;
  final bool disableTouch;
  const QuickActionsWidget({
    super.key,
    required this.user,
    this.disableTouch = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        // color:Theme.of(context).secondaryHeaderColor,
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Quick Actions',
              textAlign: TextAlign.start,
              // style: Theme.of(context).textTheme.headlineMedium
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).shadowColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            children: [
              GridView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  // crossAxisSpacing: 0,
                  // mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                children: [
                  QuickActionCard(
                      icon: Icons.file_copy,
                      title: 'Files',
                      onTap: () {
                        if (disableTouch) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HealthDocumentsPage(
                              patientId: user.uid,
                            ),
                          ),
                        );
                      }),
                  QuickActionCard(
                      icon: Icons.qr_code_scanner,
                      title: 'Scan',
                      onTap: () {
                        if (disableTouch) return;
                        QRScanner.scanQRCode().then((value) async {
                          AppUser? resultUser =
                              await ConnectUsers.getUserDetails(value);
                          ToastMessage Toast = ToastMessage();
                          if (resultUser == null) {
                            Toast.showError(
                                "Qr Code does not belong to a valid user");
                          } else if (user.uid == resultUser.uid) {
                            Toast.showError("Can't add yourself");
                          } else if (user.userType == resultUser.userType) {
                            Toast.showError(
                                "Can't add user who is a ${resultUser.userType.capitalisedName}");
                          } else {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    QRResultPage(appUser: resultUser),
                              ),
                            );
                          }
                          // Navigator.of(context).pop();
                        });
                      }),
                  QuickActionCard(
                    icon: Icons.timeline,
                    title: 'Timeline',
                    onTap: () {
                      if (disableTouch) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExtendedTimelinePage(
                            patient: user,
                          ),
                        ),
                      );
                    },
                  ),
                  QuickActionCard(
                    icon: Icons.add,
                    title: 'Activity',
                    onTap: () {
                      if (disableTouch) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TaskFormPage(
                                  patient: user,
                                )),
                      );
                    },
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;

  final void Function()? onTap;
  const QuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 0,
        ),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.8),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).highlightColor,
                    offset: const Offset(0, 0.5),
                    blurRadius: 0,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 20,
                color: Colors.white,
                // color: Color.fromARGB(157, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 6),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
