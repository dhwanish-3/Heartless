// ! if it is possible discard this page and use the dayWiseLog page by passing the diaryList Widget as a paramter

import 'package:calendar_slider/calendar_slider.dart';
import 'package:flutter/material.dart';
import 'package:heartless/main.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:heartless/widgets/log/diary_list.dart';

class DayWiseDiary extends StatelessWidget {
  const DayWiseDiary({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetNotifier widgetNotifier = Provider.of<WidgetNotifier>(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //! code for adding new diary
          },
          backgroundColor: Constants.primaryColor,
          child: const Icon(Icons.add),
        ),
        appBar: CalendarSlider(
          // controller: calendarSliderController,
          selectedDayPosition: SelectedDayPosition.center,
          fullCalendarWeekDay: WeekDay.short,
          selectedTileBackgroundColor: Constants.primaryColor,
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
        body: const SafeArea(
            child: SingleChildScrollView(
          child: Column(children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: DiaryList()),
          ]),
        )));
  }
}
