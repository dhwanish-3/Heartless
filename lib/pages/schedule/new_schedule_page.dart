import 'package:calendar_slider/calendar_slider.dart';
import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/widgets/schedule/multi_toggle_panel.dart';
import 'package:heartless/widgets/schedule/reminder_card.dart';

const data = [
  {
    "time": "9:00 AM",
    "title": "Paracetamol",
    "description": "the best medicine out there",
    "type": 0,
    "status": 0
  },
  {
    "time": "11:00 AM",
    "title": "Cereal",
    "type": 1,
    "status": 0,
    "description": "food is good",
  },
  {
    "time": "9:00 PM",
    "title": "Paracetamol",
    "description": "the best medicine out there",
    "type": 2,
    "status": 0
  },
  {
    "time": "11:00 PM",
    "title": "Cereal",
    "type": 1,
    "status": 0,
    "description": "Food is good for health",
  },
  {
    "time": "11:00 AM",
    "title": "Cereal",
    "type": 1,
    "status": 0,
    "description": "food is good",
  },
  {
    "time": "9:00 PM",
    "title": "Paracetamol",
    "description": "the best medicine out there",
    "type": 2,
    "status": 0
  },
  {
    "time": "11:00 PM",
    "title": "Cereal",
    "type": 0,
    "status": 1,
    "description": "Food is good for health",
  },
  {
    "time": "11:00 PM",
    "title": "Cereal",
    "type": 2,
    "status": 2,
    "description": "Food is good for health",
  },
];

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(180),
        child: Column(
          children: [
            CalendarSlider(
              // controller: calendarSliderController, //* controller is not needed here
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
                //* choice to be made as to whether this be made as a stateful widget or be rebuilt with provider
                // setState(() {
                //   selectedDateAppBBar = date;
                //   debugPrint(selectedDateAppBBar.toString());
                // });
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
            ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Reminder(
                    title: data[index]['title'] as String,
                    description: data[index]['description'] as String,
                    time: data[index]['time'] as String,
                    type: data[index]['type'] as int,
                    status: data[index]['status'] as int,
                  ),
                );
              },
            ),
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
