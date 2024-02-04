import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:heartless/widgets/analytics/month_slider.dart';
import 'package:heartless/widgets/analytics/radial.dart';
import 'package:heartless/widgets/analytics/spline_area.dart';
import 'package:heartless/widgets/analytics/stacked_col.dart';

class GraphsWidget extends StatefulWidget {
  const GraphsWidget({super.key});

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
            // make the api call to fetch data of corresponding month and year here
          },
        ),
        const SizedBox(
          height: 180,
          width: 400,
          child: SplineAreaChart(),
        ),
        const SizedBox(height: 20),
        const SizedBox(
          height: 180,
          width: 400,
          child: StackedColumnChart(),
        ),
        const SizedBox(height: 20),
        const SizedBox(
          height: 180,
          width: 400,
          child: RadialBarChart(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
