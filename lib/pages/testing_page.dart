import 'package:flutter/material.dart';

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
        child: Text("Testing Page"),
      ),
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