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
      ChartData('David', 50),
      ChartData('Steve', 76),
      ChartData('Jack', 68),
      ChartData('Others', 90)
    ];
    return Scaffold(
        body: Center(
            child: Container(
                child: SfCircularChart(series: <CircularSeries>[
      // Renders radial bar chart
      RadialBarSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          cornerStyle: CornerStyle.bothCurve,
          // useSeriesColor: true,
          // trackOpacity: 0.3,
          maximumValue: 100,
          dataLabelSettings: const DataLabelSettings(
              // Renders the data label
              isVisible: true,
              textStyle: TextStyle(fontSize: 15)))
    ]))));
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
