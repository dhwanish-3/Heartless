import 'package:flutter/material.dart';
import 'package:heartless/pages/patient_management/patient_management_profile_page.dart';
import 'package:heartless/pages/profile/settings/static_data.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/widgets/patient_management/person_info.dart';

class StaticPatientManagement extends StatelessWidget {
  final AppUser user;
  const StaticPatientManagement({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.arrow_back,
          ),
          centerTitle: true,
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
                    user: user,
                    disableTouch: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ControlPanel(
                    patient: StaticData.user,
                    disableTouch: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SupervisorListContainer(),
                  const SizedBox(height: 20),
                ]),
          ),
        ));
  }
}

class SupervisorListContainer extends StatelessWidget {
  const SupervisorListContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<AppUser> supervisorList = StaticData.supervisorList;
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
                onPressed: () {},
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
