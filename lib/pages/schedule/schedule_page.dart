import 'package:calendar_slider/calendar_slider.dart';
import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/activity_controller.dart';
import 'package:heartless/main.dart';
import 'package:heartless/services/enums/schedule_toggle_type.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/shared/models/activity.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:heartless/widgets/schedule/multi_toggle_panel.dart';
import 'package:heartless/widgets/schedule/reminder_card.dart';

class SchedulePage extends StatelessWidget {
  final AppUser patient;
  const SchedulePage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    WidgetNotifier widgetNotifier = Provider.of<WidgetNotifier>(context);
    Widget buildScheduleWidget(Activity activity) {
      // if the toggle is not in all tab, then show the reminders of the selected type
      if (widgetNotifier.scheduleToggleType != ScheduleToggleType.all) {
        return widgetNotifier.scheduleToggleType.type == activity.type
            ? Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: ReminderCard(
                  activity: activity,
                ),
              )
            : Container();
      } else {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: ReminderCard(
            activity: activity,
          ),
        );
      }
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(180),
        child: Column(
          children: [
            CalendarSlider(
              //     // controller: calendarSliderController, //* controller is not needed here
              selectedDayPosition: SelectedDayPosition.center,
              fullCalendarWeekDay: WeekDay.short,
              selectedTileBackgroundColor: Constants.primaryColor,
              monthYearButtonBackgroundColor: Constants.cardColor,
              monthYearTextColor: Colors.black,
              tileBackgroundColor: Theme.of(context).cardColor,
              selectedDateColor: Colors.white,
              dateColor: Theme.of(context).shadowColor,
              locale: 'en',
              initialDate: widgetNotifier.selectedDate,
              firstDate: DateTime.now().subtract(const Duration(days: 180)),
              lastDate: DateTime.now().add(const Duration(days: 100)),
              onDateSelected: (date) async {
                widgetNotifier.setSelectedDate(date);
              },
            ),
            const MutltiToggle(),
          ],
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
                stream: ActivityController.getAllActivitiesOfTheDate(
                    widgetNotifier.selectedDate, patient.uid),
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
                          return buildScheduleWidget(activity);
                        });
                  } else {
                    return const Center(
                      child: Text("No reminders yet"),
                    );
                  }
                }),
          ],
        ),
      )),
    );
  }
}

class MySlider extends StatefulWidget {
  const MySlider({super.key});

  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  bool isLeft = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isLeft = !isLeft;
        });
      },
      child: Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: isLeft ? 0 : 100,
              child: Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
