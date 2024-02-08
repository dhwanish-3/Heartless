import 'package:flutter/material.dart';
import 'package:heartless/widgets/schedule/calendar.dart';
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
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const HorizontalCalendar(),
            const SizedBox(height: 10),
            const MutltiToggle(),
            // const MySlider(),
            const SizedBox(height: 20),
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
