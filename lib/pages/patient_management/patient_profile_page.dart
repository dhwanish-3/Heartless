import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/chat_controller.dart';
import 'package:heartless/backend/controllers/connect_users_controller.dart';
import 'package:heartless/main.dart';
import 'package:heartless/pages/analytics/analytics_page.dart';
import 'package:heartless/pages/chat/chat_page.dart';
import 'package:heartless/pages/log/medical_log_page.dart';
import 'package:heartless/pages/schedule/schedule_page.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/models/chat.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/widgets/patient_management/person_info.dart';

class PatientProfilePage extends StatefulWidget {
  final AppUser patient;
  const PatientProfilePage({super.key, required this.patient});

  @override
  State<PatientProfilePage> createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  List<AppUser> supervisors = [];

  @override
  void initState() {
    ConnectUsersController.getAllUsersConnectedToPatient(widget.patient.uid)
        .then((value) {
      setState(() {
        supervisors = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PersonalInfoWidget(
                name: widget.patient.name,
                imageUrl: widget.patient.imageUrl,
              ),
              const SizedBox(
                height: 20,
              ),
              ControlPanel(
                patient: widget.patient,
              ),
              const SizedBox(
                height: 20,
              ),
              supervisors.isNotEmpty
                  ? SupervisorListContainer(
                      supervisorList: supervisors,
                    )
                  : Container(),
            ]),
      ),
    ));
  }
}

class SupervisorListContainer extends StatelessWidget {
  final List<AppUser> supervisorList;
  const SupervisorListContainer({super.key, required this.supervisorList});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Constants.cardColor
            : Constants.darkCardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('  Attended to By',
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(
            height: 4,
          ),
          Column(
            children: supervisorList.map((supervisor) {
              return Column(
                children: [
                  SupervisorTile(
                    imageUrl: supervisor.imageUrl,
                    name: supervisor.name,
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}

class SupervisorTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  const SupervisorTile({
    super.key,
    required this.imageUrl,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                imageUrl,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                name,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ));
  }
}

class ControlPanel extends StatelessWidget {
  final AppUser patient;
  const ControlPanel({
    super.key,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    // navigate to chat page
    void goToChat(ChatRoom chatRoom, AppUser chatUser) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ChatPage(chatRoom: chatRoom, chatUser: chatUser),
          ));
    }

    void createNewChat(AppUser user) async {
      ChatRoom? chatRoom =
          await ChatController().createChatRoom(authNotifier, user);
      if (chatRoom != null) {
        goToChat(chatRoom, user);
      }
    }

    return Container(
        // height: height * 0.3,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Constants.cardColor
              : Constants.darkCardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('  Control Panel',
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 330,
              child: GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  children: [
                    PanelCard(
                      imageUrl: 'assets/Icons/schedule.png',
                      text: 'Schedule',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SchedulePage(
                                      patient: patient,
                                    )));
                      },
                    ),
                    PanelCard(
                      imageUrl: 'assets/Icons/charts.png',
                      text: 'Analytics',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AnalyticsPage(
                                      patientId: patient.uid,
                                    )));
                      },
                    ),
                    PanelCard(
                        imageUrl: 'assets/Icons/chat.png',
                        text: 'Chat',
                        onTap: () {
                          createNewChat(patient);
                        }),
                    PanelCard(
                      imageUrl: 'assets/Icons/diary.png',
                      text: 'Health Log',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => MedicalLogPage(
                                      patient: patient,
                                    )));
                      },
                    ),
                  ]),
            )
          ],
        ));
  }
}

class PanelCard extends StatelessWidget {
  final String imageUrl;
  final String text;
  final Function() onTap;
  const PanelCard({
    super.key,
    required this.imageUrl,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: 140,
          width: 150,
          decoration: BoxDecoration(
            color: Constants.lightPrimaryColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey
                    : Colors.black,
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 60,
                  child: Column(
                    children: [
                      Image.asset(
                        imageUrl,
                        height: 35,
                      ),
                      Text(text,
                          style: const TextStyle(
                            color: Colors.black,
                          )
                          // style: Theme.of(context).textTheme.bodySmall,
                          )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
