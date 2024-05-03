import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/activity_controller.dart';
import 'package:heartless/pages/home/doctor_nurse_home_page.dart';
import 'package:heartless/services/date/date_service.dart';
import 'package:heartless/shared/models/activity.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:heartless/widgets/home/activity_schedule.dart';
import 'package:heartless/widgets/home/heading_widget.dart';
import 'package:heartless/widgets/home/quick_actions_widget.dart';
import 'package:provider/provider.dart';

class PatientHomePage extends StatelessWidget {
  final AppUser user;

  const PatientHomePage({
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
              ),
              QuickActionsWidget(
                user: user,
              ),
              const SizedBox(height: 20),
              ActivitiesSchedule(context),
              const SizedBox(height: 20),
              DemoPreviewWidget(pageController: _pageController),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Container ActivitiesSchedule(BuildContext context) {
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);
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
              Consumer<WidgetNotifier>(builder: (context, value, child) {
                return StreamBuilder(
                    stream: ActivityController.getAllActivitiesOfTheDate(
                        DateTime.now(), user.uid,
                        limit: 3, reverse: true),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.docs.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              Activity activity = Activity.fromMap(
                                  snapshot.data.docs[index].data()
                                      as Map<String, dynamic>);
                              return ActivityScheduleEntry(
                                  title: activity.name,
                                  time: DateService.getFormattedTime(
                                      activity.time),
                                  comment: activity.description,
                                  status: activity.status,
                                  type: activity.type);
                            });
                      } else {
                        return const Center(
                          child: Text("No reminders yet"),
                        );
                      }
                    });
              }),
            ],
          ),
        ],
      ),
    );
  }
}
