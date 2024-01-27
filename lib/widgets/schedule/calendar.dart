import 'dart:math';

import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/widgets/schedule/calender_agenda.dart';
import 'package:heartless/widgets/schedule/full_calendar.dart';

class HorizontalCalendar extends StatefulWidget {
  const HorizontalCalendar({super.key});

  @override
  State<HorizontalCalendar> createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  final CalendarAgendaController _calendarAgendaControllerNotAppBar =
      CalendarAgendaController();
  DateTime _selectedDateNotAppBBar = DateTime.now();

  Random random = Random();

  @override
  Widget build(BuildContext context) {
    return CalendarAgenda(
      backgroundColor: Colors.transparent,
      dateColor: Colors.black,
      controller: _calendarAgendaControllerNotAppBar,

      // ! must discuss with user Harikrishnan
      // leading: GestureDetector(
      //     onTap: () {
      //       _calendarAgendaControllerNotAppBar.goToDay(DateTime.now());
      //     },
      //     child: Image.asset(
      //       'assets/Icons/todo.png',
      //       height: 40,
      //       color: Colors.black,
      //     )),
      locale: 'en',
      appbar: false,
      weekDay: WeekDay.short,
      fullCalendarDay: WeekDay.short,
      selectedDateColor: Colors.white,
      selectedDayPosition: SelectedDayPosition.center,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 180)),
      lastDate: DateTime.now().add(const Duration(days: 180)),
      fullCalendarScroll: FullCalendarScroll.horizontal,
      onDateSelected: (date) {
        setState(() {
          _selectedDateNotAppBBar = date;
        });
      },
    );
  }
}
