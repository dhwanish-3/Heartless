import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RadialBarChart extends StatefulWidget {
  const RadialBarChart({super.key});

  @override
  State<RadialBarChart> createState() => _RadialBarChartState();
}

class _RadialBarChartState extends State<RadialBarChart> {
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('David', 25),
      ChartData('Steve', 38),
      ChartData('Jack', 34),
      ChartData('Others', 52)
    ];
    return Scaffold(
        body: Center(
            child: Container(
                child: SfCircularChart(series: <CircularSeries>[
      // Renders radial bar chart
      RadialBarSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y)
    ]))));
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
