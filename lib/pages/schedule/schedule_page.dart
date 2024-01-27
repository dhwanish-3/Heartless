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
    "time": "11:00 PM",
    "title": "Cereal",
    "type": 2,
    "status": 0,
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
            const SizedBox(height: 20),
            const MutltiToggle(),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: Colors.grey[300],
              child: Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
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
              ),
            ),
          ],
        ),
      )),
    );
  }
}
