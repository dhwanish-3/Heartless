import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class StackedColumnChart extends StatefulWidget {
  const StackedColumnChart({super.key});

  @override
  State<StackedColumnChart> createState() => _StackedColumnChartState();
}

class _StackedColumnChartState extends State<StackedColumnChart> {
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      // ChartData('China', 12, 10, 14, 20),
      // ChartData('USA', 14, 11, 18, 23),
      // ChartData('UK', 16, 10, 15, 20),
      // ChartData('Brazil', 18, 16, 18, 24),
      // ChartData('India', 12, 11, 15, 24),
      // ChartData('Russia', 16, 18, 14, 23),

      ChartData('UK', 16, 10),
      ChartData('Brazil', 18, 16),
      ChartData('China', 12, 11),
      ChartData('US', 16, 18),
      ChartData('Russia', 14, 10),
      ChartData('India', 12, 16),
    ];

    return Scaffold(
        body: Center(
            child: Container(
                child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    series: <CartesianSeries>[
          StackedColumnSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y1),
          StackedColumnSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y2),
          // StackedColumnSeries<ChartData, String>(
          //     dataSource: chartData,
          //     xValueMapper: (ChartData data, _) => data.x,
          //     yValueMapper: (ChartData data, _) => data.y3),
          // StackedColumnSeries<ChartData, String>(
          //     dataSource: chartData,
          //     xValueMapper: (ChartData data, _) => data.x,
          //     yValueMapper: (ChartData data, _) => data.y4)
        ]))));
  }
}

class ChartData {
  ChartData(this.x, this.y1, this.y2);
  final String x;
  final double y1;
  final double y2;
  // final double y3;
  // final double y4;
}
