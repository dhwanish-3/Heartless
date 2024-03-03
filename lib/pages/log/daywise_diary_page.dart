import 'package:calendar_slider/calendar_slider.dart';
import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/widgets/log/diary_list.dart';
import 'package:heartless/widgets/schedule/calendar.dart';

class DayWiseDiary extends StatefulWidget {
  const DayWiseDiary({super.key});

  @override
  State<DayWiseDiary> createState() => _DayWiseDiaryState();
}

class _DayWiseDiaryState extends State<DayWiseDiary> {
  @override
  final CalendarSliderController calendarSliderController =
      CalendarSliderController();

  late DateTime selectedDateAppBBar;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //! code for adding new diary
          },
          backgroundColor: Constants.primaryColor,
          child: const Icon(Icons.add),
        ),
        appBar: CalendarSlider(
          controller: calendarSliderController,
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
            setState(() {
              selectedDateAppBBar = date;
              debugPrint(selectedDateAppBBar.toString());
            });
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
