import 'package:calendar_slider/calendar_slider.dart';
import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/activity_controller.dart';
import 'package:heartless/pages/schedule/create_task_page.dart';
import 'package:heartless/services/enums/schedule_toggle_type.dart';
import 'package:heartless/services/enums/user_type.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/shared/models/activity.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:heartless/widgets/schedule/multi_toggle_panel.dart';
import 'package:heartless/widgets/schedule/reminder_card.dart';
import 'package:provider/provider.dart';

class SchedulePage extends StatelessWidget {
  final AppUser patient;
  const SchedulePage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    Widget buildScheduleWidget(Activity activity) {
      // if the toggle is not in all tab, then show the reminders of the selected type
      if (widgetNotifier.scheduleToggleType != ScheduleToggleType.all) {
        return widgetNotifier.scheduleToggleType.type == activity.type
            ? Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: ReminderCard(
                  activity: activity,
                  patient: patient,
                ),
              )
            : Container();
      } else {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: ReminderCard(
            activity: activity,
            patient: patient,
            isPatient: authNotifier.userType == UserType.patient,
          ),
        );
      }
    }

    //* setting the selected date to today without notifying the listeners (if notified, it will rebuild the whole widget tree & lead to error, which is not needed here)
    widgetNotifier.setSelectedDateWithoutNotifying(DateTime.now());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: Column(
          children: [
            CalendarSlider(
              //     // controller: calendarSliderController, //* controller is not needed here
              selectedDayPosition: SelectedDayPosition.center,
              fullCalendarWeekDay: WeekDay.short,
              selectedTileBackgroundColor: Theme.of(context).primaryColor,
              monthYearButtonBackgroundColor: Constants.cardColor,
              monthYearTextColor: Colors.black,
              tileBackgroundColor: Theme.of(context).cardColor,
              selectedDateColor: Colors.white,
              dateColor: Theme.of(context).shadowColor,
              locale: 'en',
              initialDate: widgetNotifier.selectedDate,
              firstDate: DateTime.now().subtract(const Duration(days: 180)),
              lastDate: DateTime.now().add(const Duration(days: 100)),
              onDateSelected: (date) {
                widgetNotifier.setSelectedDate(date);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            const MutltiToggle(),
          ],
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<WidgetNotifier>(builder: (context, value, child) {
              return StreamBuilder(
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
                  });
            }),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add, size: 30),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => TaskFormPage(patient: patient)));
          }),
    );
  }
}
