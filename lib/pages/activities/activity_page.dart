import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:heartless/widgets/activity/pie_chart.dart';
import 'package:heartless/widgets/activity/radial.dart';
import 'package:heartless/widgets/activity/spline_area.dart';
import 'package:heartless/widgets/activity/stacked_col.dart';
import 'package:heartless/widgets/activity/doughnut.dart';




class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {

    // return const StackedColumnChart();
    return const SplineAreaChart();
    // return const RadialBarChart();
    // return const DoughnutChart();
    // return const PieChart();
    // return const HorizontalCalendar();
    
    
  }
}