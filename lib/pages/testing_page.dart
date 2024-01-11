import 'package:flutter/material.dart';
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
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Icons/nutritionCard.png',
                  height: 150,
                  width: 150,
                ),
                Image.asset(
                  'assets/Icons/exerciseCard.png',
                  height: 150,
                  width: 150,
                ),
                Image.asset(
                  'assets/Icons/medicineCard.png',
                  height: 150,
                  width: 150,
                ),
                Image.asset(
                  'assets/Icons/genericCard.png',
                  height: 150,
                  width: 150,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Icons/heartRateCard.png',
                  height: 150,
                  width: 150,
                ),
                Image.asset(
                  'assets/Icons/bpCard.png',
                  height: 150,
                  width: 150,
                ),
                Image.asset(
                  'assets/Icons/weightCard.png',
                  height: 150,
                  width: 150,
                ),
                Image.asset(
                  'assets/Icons/glucoseCard.png',
                  height: 150,
                  width: 150,
                ),
                const Reminder(
                    title: 'Paracetoamol',
                    description: "the best medicine out there",
                    time: '9:00 AM',
                    type: 0),
                const Reminder(
                    title: 'Paracetoamol',
                    description: "the best medicine out there",
                    time: '9:00 AM',
                    type: 0,
                    status: 2),
              ],
            ),
          ],
        ),
      ),
    ));
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