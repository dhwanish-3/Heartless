import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChart extends StatefulWidget {
  const PieChart({super.key});

  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Colors.lightBlue,
      Colors.lime,
      Colors.orangeAccent,
      Colors.lightGreen,
      Colors.redAccent,
    ];

    int i = 0;
    final List<PieChartData> chartData = [
      PieChartData('David', 25, colors[i++]),
      PieChartData('Steve', 38, colors[i++]),
      PieChartData('Jack', 34, colors[i++]),
      PieChartData('Others', 52, colors[i++])
    ];

    return Scaffold(
        body: Center(
            child: Container(
                child: SfCircularChart(series: <CircularSeries>[
      // Render pie chart
      PieSeries<PieChartData, String>(
          dataSource: chartData,
          pointColorMapper: (PieChartData data, _) => data.color,
          xValueMapper: (PieChartData data, _) => data.x,
          yValueMapper: (PieChartData data, _) => data.y,
          explode: true,
          explodeGesture: ActivationMode.singleTap,
          dataLabelMapper: (PieChartData data, _) => "${data.x}\n${data.y}",
          dataLabelSettings: const DataLabelSettings(
              // Renders the data label
              isVisible: true,
              textStyle: TextStyle(fontSize: 17)))
    ]))));
  }
}

class PieChartData {
  PieChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}
