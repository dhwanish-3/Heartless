import 'package:flutter/material.dart';
import 'package:heartless/pages/profile/settings/static_data.dart';
import 'package:heartless/services/date/date_service.dart';
import 'package:heartless/shared/models/activity.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/widgets/home/activity_schedule.dart';
import 'package:heartless/widgets/home/heading_widget.dart';
import 'package:heartless/widgets/home/quick_actions_widget.dart';

class StaticHomePage extends StatelessWidget {
  final AppUser user;
  const StaticHomePage({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              HomePageHeadingWidget(
                user: user,
                disableSearch: true,
              ),
              QuickActionsWidget(),
              const SizedBox(height: 20),
              ActivitiesSchedule(context),
              // const SizedBox(height: 20),
              // DemoPreviewWidget(pageController: _pageController),
            ],
          ),
        ),
      ),
    );
  }
}

Container ActivitiesSchedule(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(
      horizontal: 30,
    ),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      // color: Theme.of(context).secondaryHeaderColor,
      borderRadius: BorderRadius.circular(10),
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
      vertical: 20,
      horizontal: 10,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Text(
            'Your Activites',
            textAlign: TextAlign.start,
            // style: Theme.of(context).textTheme.headlineMedium
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).shadowColor,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: StaticData.activityList.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  Activity activity = StaticData.activityList[index];
                  return ActivityScheduleEntry(
                      title: activity.name,
                      time: DateService.getFormattedTime(activity.time),
                      comment: activity.description,
                      status: activity.status,
                      type: activity.type);
                })
          ],
        ),
      ],
    ),
  );
}
