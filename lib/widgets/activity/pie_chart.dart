import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class PieChart extends StatefulWidget {
  const PieChart({super.key});

  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  // @override
  // Widget build(BuildContext context) {
  //   return const Placeholder();
  // }
  @override
  Widget build(BuildContext context) {

    final List<Color> colors = [
      Colors.lightBlue,
      Colors.lime,
      Colors.orangeAccent,
      Colors.lightGreen,
      Colors.redAccent,
    ];

    var i=0;
    final List<ChartData> chartData = [
      ChartData('David', 25, colors[i++]),
      ChartData('Steve', 38,colors[i++]),
      ChartData('Jack', 34, colors[i++]),
      ChartData('Others', 52, colors[i++])
    ];

    return Scaffold(
        body: Center(
            child: Container(
                child: SfCircularChart(series: <CircularSeries>[
      // Render pie chart
      PieSeries<ChartData, String>(
          dataSource: chartData,
          pointColorMapper: (ChartData data, _) => data.color,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          explode: true,
          explodeGesture: ActivationMode.singleTap,
          dataLabelMapper: (ChartData data, _) =>
              data.x.toString() + "\n" + data.y.toString(),
          dataLabelSettings: const DataLabelSettings(
              // Renders the data label
              isVisible: true,
              textStyle: TextStyle(fontSize: 17)))
    ]))));
  }
}

class ChartData {
  // ChartData(this.x, this.y);
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}
