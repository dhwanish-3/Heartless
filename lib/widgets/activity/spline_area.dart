import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SplineAreaChart extends StatefulWidget {
  const SplineAreaChart({super.key});

  @override
  State<SplineAreaChart> createState() => _SplineAreaChartState();
}

class _SplineAreaChartState extends State<SplineAreaChart> {
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = <ChartData>[
      ChartData(2010, 10.53, 3.3),
      ChartData(2011, 9.5, 5.4),
      ChartData(2012, 10, 2.65),
      ChartData(2013, 9.4, 2.62),
      ChartData(2014, 5.8, 1.99),
      ChartData(2015, 4.9, 1.44),
      ChartData(2016, 4.5, 2),
      ChartData(2017, 3.6, 1.56),
      ChartData(2018, 3.43, 2.1),
    ];
    return Scaffold(
        body: Center(
            child: SfCartesianChart(series: <CartesianSeries>[
      SplineAreaSeries<ChartData, int>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y),
      SplineAreaSeries<ChartData, int>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y1),
    ])));
  }
}

class ChartData {
  ChartData(this.x, this.y, this.y1);
  final int x;
  final double y;
  final double y1;
}
