import 'package:flutter/material.dart';
import 'package:heartless/services/enums/activity_status.dart';
import 'package:heartless/services/enums/activity_type.dart';
import 'package:heartless/widgets/home/activity_schedule.dart';
import 'package:heartless/widgets/home/heading_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            HomePageHeadingWidget(),
            Container(
              margin: const EdgeInsets.only(
                left: 40,
              ),
              child: Column(
                children: [
                  ActivityScheduleEntry(
                    title: 'Morning Walk',
                    time: '9:00 AM',
                    comment: 'Walk for 30 minutes',
                    status: ActivityStatus.completed,
                    type: ActivityType.exercise,
                  ),
                  ActivityScheduleEntry(
                    title: 'Afternoon Walk',
                    time: '2:00 PM',
                    comment: 'Walk for 30 minutes',
                    status: ActivityStatus.missed,
                    type: ActivityType.diet,
                  ),
                  ActivityScheduleEntry(
                    title: 'Evening Walk',
                    time: '6:00 PM',
                    comment: 'Walk for 30 minutes',
                    status: ActivityStatus.upcoming,
                    type: ActivityType.medicine,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
