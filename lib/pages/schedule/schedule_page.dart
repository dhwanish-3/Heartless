import 'package:flutter/material.dart';
import 'package:heartless/widgets/activity/calendar.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: HorizontalCalendar()),
    );
  }
}
