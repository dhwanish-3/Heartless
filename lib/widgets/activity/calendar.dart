import 'dart:math';

import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:flutter/material.dart';

class HorizontalCalendar extends StatefulWidget {
  const HorizontalCalendar({super.key});

  @override
  State<HorizontalCalendar> createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  CalendarAgendaController _calendarAgendaControllerAppBar =
      CalendarAgendaController();
  CalendarAgendaController _calendarAgendaControllerNotAppBar =
      CalendarAgendaController();

  late DateTime _selectedDateAppBBar;
  late DateTime _selectedDateNotAppBBar;

  Random random = new Random();


  // @override
  // void initState() {
  //   _selectedDateAppBBar = DateTime.now();
  //   _selectedDateNotAppBBar = DateTime.now();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
      
          children: [
            CalendarAgenda(
              selectedDayPosition: SelectedDayPosition.center,
              controller: _calendarAgendaControllerNotAppBar,
              backgroundColor: Colors.white,
              // leading: SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.3,
              //   child: Text(
              //     "Agenda anda hari ini adalah sebagai berikut",
              //     style: TextStyle(
              //       color: Colors.white,
              //     ),
              //     overflow: TextOverflow.ellipsis,
              //   ),
              // ),
              // fullCalendar: false,
              dateColor: Colors.black,
              locale: 'en',
              weekDay: WeekDay.short,
              fullCalendarDay: WeekDay.short,

              selectedDateColor: Colors.blue.shade900,
              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(Duration(days: 140)),
              lastDate: DateTime.now().add(Duration(days: 4)),
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
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
