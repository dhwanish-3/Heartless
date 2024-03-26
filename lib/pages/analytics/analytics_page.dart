import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:heartless/services/enums/activity_type.dart';
import 'package:heartless/services/enums/medical_reading_type.dart';
import 'package:heartless/widgets/analytics/blood_pressure_chart.dart';
import 'package:heartless/widgets/analytics/display_mode_selector.dart';
import 'package:heartless/widgets/analytics/general_reading_chart.dart';
import 'package:heartless/widgets/analytics/line_default_chart.dart';
import 'package:heartless/widgets/analytics/radial_bar_chart.dart';
import 'package:heartless/widgets/auth/custom_two_button_toggle.dart';

class AnalyticsPage extends StatefulWidget {
  final String patientId;
  const AnalyticsPage({super.key, required this.patientId});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Column(
          children: [
            AppBar(
              centerTitle: true,
              title: const Text(
                'Analytics',
                textAlign: TextAlign.center,
              ),
              surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: DisplayModeSelector(
                onDateChanged: (DateTime startDate, DateTime endDate) {
                  log('Start Date: $startDate, End Date: $endDate');
                  // todo: make the api call to fetch data of corresponding month and year here
                },
              ),
            ),
            // const SizedBox(height: 20),
            // TwoButtonToggle(emailPhoneToggle: false),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: TwoButtonToggle(
          emailPhoneToggle: false,
          leftButtonText: 'Activites',
          rightButtonText: 'Readings',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RadialBarChart(
                patientId: widget.patientId,
                date: DateTime.now(),
              ),
              LineDefaultChart(
                activityType: ActivityType.exercise,
                patientId: widget.patientId,
                date: DateTime.now(),
              ),
              LineDefaultChart(
                activityType: ActivityType.medicine,
                patientId: widget.patientId,
                date: DateTime.now(),
              ),
              LineDefaultChart(
                activityType: ActivityType.diet,
                patientId: widget.patientId,
                date: DateTime.now(),
              ),
              BloodPressureChart(
                patientId: widget.patientId,
                date: DateTime.now(),
              ),
              GeneralReadingChart(
                patientId: widget.patientId,
                readingType: MedicalReadingType.weight,
                date: DateTime.now(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
