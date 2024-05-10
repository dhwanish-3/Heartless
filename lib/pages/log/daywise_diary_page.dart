import 'package:calendar_slider/calendar_slider.dart';
import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:heartless/widgets/log/add_button.dart';
import 'package:heartless/widgets/log/cutom_rect.dart';
import 'package:heartless/widgets/log/diary_list.dart';
import 'package:heartless/widgets/log/hero_dialog.dart';
import 'package:provider/provider.dart';

const String _heroAddTodo = 'add-todo-hero';

//! This page is not being used anymore
class DayWiseDiary extends StatelessWidget {
  final AppUser patient;
  const DayWiseDiary({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);

    //* setting the selected date to today without notifying the listeners (if notified, it will rebuild the whole widget tree & lead to error, which is not needed here)
    widgetNotifier.setSelectedDateWithoutNotifying(DateTime.now());

    return Scaffold(
        appBar: CalendarSlider(
          // controller: calendarSliderController,
          selectedDayPosition: SelectedDayPosition.center,
          fullCalendarWeekDay: WeekDay.short,
          selectedTileBackgroundColor: Theme.of(context).primaryColor,
          monthYearButtonBackgroundColor: Constants.cardColor,
          monthYearTextColor: Colors.black,
          tileBackgroundColor: Theme.of(context).cardColor,
          selectedDateColor: Colors.white,
          dateColor: Theme.of(context).shadowColor,
          locale: 'en',
          initialDate: DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 180)),
          lastDate: DateTime.now().add(const Duration(days: 100)),
          onDateSelected: (date) {
            widgetNotifier.setSelectedDate(date);
          },
        ),
        body: Stack(
          children: [
            Column(children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DiaryListBuilder(
                    patient: patient,
                  )),
            ]),
            // * the below widget is the floatingActionButton
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: GestureDetector(
                  onTap: () async {
                    await Navigator.of(context)
                        .push(HeroDialogRoute(builder: (context) {
                      return AddDiaryPopUpCard(
                        patient: patient,
                      );
                    }));
                  },
                  child: Hero(
                    tag: _heroAddTodo,
                    createRectTween: (begin, end) {
                      return CustomRectTween(
                          begin: begin as Rect, end: end as Rect);
                    },
                    child: Align(
                      alignment: const Alignment(1.1, 1.05),
                      child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        color: Colors.transparent,
                        elevation: 10,
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromARGB(255, 77, 250, 204),
                                Color.fromARGB(255, 71, 200, 255),
                                Color.fromARGB(255, 30, 255, 150),
                              ],
                              stops: [0, 0, 1],
                            ),
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            size: 56,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
