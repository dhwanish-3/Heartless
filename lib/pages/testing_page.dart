import 'package:flutter/material.dart';
import 'package:heartless/widgets/chat_tile.dart';
import 'package:heartless/widgets/dashboard_card.dart';
import 'package:heartless/widgets/reminder_card.dart';

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
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ChatTile(
              name: 'Dr. John Dot',
              imageUrl: 'assets/avatar/User.png',
              latestMessage: 'Hello, how are you?',
              time: '10:00 AM',
              unreadMessages: 5,
            )),
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