import 'package:flutter/material.dart';
import 'package:heartless/widgets/schedule/reminder_card.dart';

class TestingPage extends StatefulWidget {
  const TestingPage({super.key});

  @override
  State<TestingPage> createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Reminder(
            title: 'Paracetamol ',
            description: "the best medicine out there",
            time: '9:00 AM',
            type: 0),
        SizedBox(height: 20),
        Reminder(
            title: 'Paracetoamol',
            description: "the best medicine out there",
            time: '9:00 AM',
            type: 0,
            status: 2),
      ])),
    );
  }
}

            // Reminder(
            //     title: 'Paracetoamol',
            //     description: "the best medicine out there",
            //     time: '9:00 AM',
            //     type: 0),
            // Reminder(
            //     title: 'Paracetoamol',
            //     description: "the best medicine out there",
            //     time: '9:00 AM',
            //     type: 0,
            //     status: 2),