import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/chat_controller.dart';
import 'package:heartless/backend/controllers/connect_users_controller.dart';
import 'package:heartless/pages/analytics/analytics_page.dart';
import 'package:heartless/pages/chat/chat_page.dart';
import 'package:heartless/pages/log/daywise_log.dart';
import 'package:heartless/pages/log/health_documents_page.dart';
import 'package:heartless/pages/profile/users_list_page.dart';
import 'package:heartless/pages/schedule/schedule_page.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/models/chat.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/widgets/patient_management/person_info.dart';
import 'package:heartless/widgets/patient_management/timeline_widget.dart';
import 'package:provider/provider.dart';

class DoctorNurseSidePatientProfile extends StatefulWidget {
  final AppUser patient;
  const DoctorNurseSidePatientProfile({super.key, required this.patient});

  @override
  State<DoctorNurseSidePatientProfile> createState() =>
      _DoctorNurseSidePatientProfileState();
}

class _DoctorNurseSidePatientProfileState
    extends State<DoctorNurseSidePatientProfile> {
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
        appBar: AppBar(
          title: Text(
            'Manage Patient',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PersonalInfoWidget(
                    user: widget.patient,
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
                  TimelineWidget(
                    patient: widget.patient,
                  ),
                  const SizedBox(height: 20),
                  supervisors.isNotEmpty
                      ? SupervisorListContainer(
                          supervisorList: supervisors,
                          patient: widget.patient,
                        )
                      : Container(),
                ]),
          ),
        ));
  }
}

class SupervisorListContainer extends StatelessWidget {
  final List<AppUser> supervisorList;
  final AppUser patient;
  const SupervisorListContainer({
    super.key,
    required this.supervisorList,
    required this.patient,
  });

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              IconButton(
                onPressed: () {
                  //navigate to UserListPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UsersListPage(
                        users: supervisorList,
                        appUser: patient,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.keyboard_arrow_right),
                color: Theme.of(context).shadowColor,
                padding: EdgeInsets.zero,
              )
            ],
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
                  childAspectRatio: 1.6,
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
                              builder: (_) => DayWiseLogPage(
                                    patient: patient,
                                  )));
                    },
                  ),
                  PanelCard(
                      imageUrl: 'assets/Icons/chat.png',
                      text: 'Documents',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HealthDocumentsPage(
                                      patientId: patient.uid,
                                    )));
                      }),
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
                          fontSize: 14,
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
