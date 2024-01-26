import 'dart:math';

import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';

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
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            CalendarAgenda(
              controller: _calendarAgendaControllerNotAppBar,

              leading: ElevatedButton(
                onPressed: () {
                  _calendarAgendaControllerNotAppBar.goToDay(DateTime.now());
                },
                child: const Text("Today"),
              ),

              locale: 'en',
              weekDay: WeekDay.long,
              fullCalendarDay: WeekDay.short,
              selectedDateColor: Constants.primaryColor,
              selectedDayPosition: SelectedDayPosition.center,

              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 180)),
              lastDate: DateTime.now().add(const Duration(days: 180)),
              fullCalendarScroll: FullCalendarScroll.horizontal,

              // events: List.generate(
              //     100,
              //     (index) => DateTime.now()
              //         .subtract(Duration(days: index * random.nextInt(5)))),
              onDateSelected: (date) {
                setState(() {
                  _selectedDateNotAppBBar = date;
                });
              },
              // calendarLogo: Image.network(
              //   'https://www.kindpng.com/picc/m/355-3557482_flutter-logo-png-transparent-png.png',
              //   scale: 5.0,
              // ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text('Selected date is $_selectedDateNotAppBBar'),
          ],
        ),
      ),
    );
  }
}
