import 'package:flutter/material.dart';
import 'package:heartless/services/enums/activity_type.dart';
import 'package:heartless/widgets/analytics/blood_pressure_chart.dart';
import 'package:heartless/widgets/analytics/line_default_chart.dart';
import 'package:heartless/widgets/analytics/month_slider.dart';
import 'package:heartless/widgets/analytics/radial_bar_chart.dart';

class GraphsWidget extends StatefulWidget {
  final String patientId;
  const GraphsWidget({super.key, required this.patientId});

  @override
  State<GraphsWidget> createState() => _GraphsWidgetState();
}

class _GraphsWidgetState extends State<GraphsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MonthYearSelector(
              onMonthYearChanged: (month, year) {
                // todo: make the api call to fetch data of corresponding month and year here
              },
            ),
            SizedBox(
              height: 230,
              width: 400,
              child: RadialBarChart(
                patientId: widget.patientId,
              ),
            ),
            SizedBox(
              height: 200,
              width: 400,
              child: LineDefaultChart(
                activityType: ActivityType.excercise,
                patientId: widget.patientId,
              ),
            ),
            SizedBox(
              height: 180,
              width: 400,
              child: LineDefaultChart(
                activityType: ActivityType.medicine,
                patientId: widget.patientId,
              ),
            ),
            SizedBox(
              height: 180,
              width: 400,
              child: LineDefaultChart(
                activityType: ActivityType.diet,
                patientId: widget.patientId,
              ),
            ),
            SizedBox(
              height: 300,
              width: 350,
              child: BloodPressureChart(
                patientId: widget.patientId,
                date: DateTime.now(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
