import 'package:flutter/material.dart';
import 'package:heartless/widgets/analytics/month_slider.dart';
import 'package:heartless/widgets/analytics/radial_bar_chart.dart';
import 'package:heartless/widgets/analytics/spline_area_chart.dart';
import 'package:heartless/widgets/analytics/stacked_column_chart.dart';

class GraphsWidget extends StatefulWidget {
  final String patientId;
  const GraphsWidget({super.key, required this.patientId});

  @override
  State<GraphsWidget> createState() => _GraphsWidgetState();
}

class _GraphsWidgetState extends State<GraphsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MonthYearSelector(
          onMonthYearChanged: (month, year) {
            // todo: make the api call to fetch data of corresponding month and year here
          },
        ),
        SizedBox(
          height: 180,
          width: 400,
          child: SplineAreaChart(
            patientId: widget.patientId,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 180,
          width: 400,
          child: StackedColumnChart(
            patientId: widget.patientId,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 180,
          width: 400,
          child: RadialBarChart(
            patientId: widget.patientId,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
