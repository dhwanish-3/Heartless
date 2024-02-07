import 'dart:math';
import 'package:flutter/material.dart';
import 'package:calendar_slider/calendar_slider.dart';

class HorizontalCalendar extends StatefulWidget {
  const HorizontalCalendar({super.key});

  @override
  State<HorizontalCalendar> createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  final CalendarSliderController _calendarSliderControllerNotAppBar =
      CalendarSliderController();
  DateTime _selectedDateNotAppBar = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return CalendarSlider(
      backgroundColor: Colors.transparent,
      dateColor: Colors.black,
      controller: _calendarSliderControllerNotAppBar,

      // ! must discuss with user Harikrishnan
      // leading: GestureDetector(
      //     onTap: () {
      //       _calendarSliderControllerNotAppBar.goToDay(DateTime.now());
      //     },
      //     child: Image.asset(
      //       'assets/Icons/todo.png',
      //       height: 40,
      //       color: Colors.black,
      //     )),
      locale: 'en',
      weekDay: WeekDay.short,
      // fullCalendarDay: WeekDay.short,
      selectedDateColor: Colors.white,
      selectedDayPosition: SelectedDayPosition.center,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 180)),
      lastDate: DateTime.now().add(const Duration(days: 180)),
      fullCalendarScroll: FullCalendarScroll.horizontal,
      onDateSelected: (date) {
        setState(() {
          _selectedDateNotAppBar = date;
        });
      },
    );
  }
}
