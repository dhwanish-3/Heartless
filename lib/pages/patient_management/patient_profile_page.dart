import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/chat_controller.dart';
import 'package:heartless/backend/controllers/connect_users_controller.dart';
import 'package:heartless/pages/chat/chat_page.dart';
import 'package:heartless/pages/log/daywise_log.dart';
import 'package:heartless/pages/log/file_upload_page.dart';
import 'package:heartless/pages/schedule/schedule_page.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/models/chat.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/widgets/analytics/graphs_widget.dart';
import 'package:heartless/widgets/patient_management/person_info.dart';
import 'package:heartless/widgets/patient_management/timeline_widget.dart';
import 'package:provider/provider.dart';

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
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FileUploadPage(
                                  patientId: widget.patient.uid,
                                )));
                  },
                  child: const Text('Documents')),
              const SizedBox(
                height: 20,
              ),
              ControlPanel(
                patient: widget.patient,
              ),
              const SizedBox(
                height: 20,
              ),
              TimelineWidget(
                patientId: widget.patient.uid,
              ),
              const SizedBox(height: 20),
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
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.circular(20),
      ),
      // padding: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attended to By',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).shadowColor,
            ),
          ),
          const SizedBox(
            height: 10,
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
        height: 56,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
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
          await ChatController().createChatRoom(authNotifier.appUser!, user);
      if (chatRoom != null) {
        goToChat(chatRoom, user);
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Control Panel',
            textAlign: TextAlign.start,
            // style: Theme.of(context).textTheme.headlineMedium
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).shadowColor,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            children: [
              GridView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.4,
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
                              builder: (context) => GraphsWidget(
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
                              builder: (_) => DayWiseLogPage(
                                    patient: patient,
                                  )));
                    },
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
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
                color: Theme.of(context).highlightColor,
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      imageUrl,
                      height: 24,
                    ),
                    Text(text,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        )
                        // style: Theme.of(context).textTheme.bodySmall,
                        )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
