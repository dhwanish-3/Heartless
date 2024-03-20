import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/activity_controller.dart';
import 'package:heartless/services/date/date_service.dart';
import 'package:heartless/services/enums/activity_status.dart';
import 'package:heartless/services/enums/activity_type.dart';
import 'package:heartless/shared/models/activity.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineDefaultChart extends StatefulWidget {
  final String patientId;
  final ActivityType activityType;
  const LineDefaultChart(
      {super.key, required this.patientId, required this.activityType});

  @override
  State<LineDefaultChart> createState() => _LineDefaultChartState();
}

class _LineDefaultChartState extends State<LineDefaultChart> {
  List<LineDefaultChartData> chartData = [];
  void getDataFromSnapshot(AsyncSnapshot snapshot) {
    if (snapshot.hasData &&
        snapshot.data != null &&
        snapshot.data.docs.isNotEmpty) {
      List<Activity> activities = [];
      snapshot.data.docs.forEach((activity) {
        if (activity.data()['type'] == widget.activityType.index) {
          activities.add(Activity.fromMap(activity.data()));
        }
      });

      Map<DateTime, List<Activity>> activitiesMap = {};
      DateTime startOfTheWeek = DateService.getStartOfWeek(DateTime.now());
      for (int i = 0; i < 7; i++) {
        activitiesMap[startOfTheWeek.add(Duration(days: i))] = [];
      }
      activities.forEach((activity) {
        if (activitiesMap
            .containsKey(DateService.getStartOfDay(activity.time))) {
          activitiesMap[DateService.getStartOfDay(activity.time)]!
              .add(activity);
        } else {
          activitiesMap[DateService.getStartOfDay(activity.time)] = [activity];
        }
      });
      List<LineDefaultChartData> newChartData = [];

      for (var map in activitiesMap.entries) {
        int total = 0;
        int completed = 0;
        map.value.forEach((activity) {
          total++;
          if (activity.status == ActivityStatus.completed) {
            completed++;
          }
        });
        newChartData.add(LineDefaultChartData(map.key, total, completed));
      }
      chartData = newChartData;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: ActivityController.getAllActivitiesForAWeek(
            DateTime.now(), widget.patientId),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data.docs.isNotEmpty) {
            getDataFromSnapshot(snapshot);
            return SfCartesianChart(
              plotAreaBorderWidth: 0,
              title: ChartTitle(text: widget.activityType.name),
              legend: Legend(
                  isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
              primaryXAxis: NumericAxis(
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  interval: 1,
                  name: "Date",
                  majorGridLines: MajorGridLines(width: 0)),
              primaryYAxis: NumericAxis(
                  interval: 1,
                  name: "Count",
                  majorTickLines: MajorTickLines(color: Colors.transparent)),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries>[
                LineSeries<LineDefaultChartData, int>(
                    dataSource: chartData,
                    color: widget.activityType.color,
                    xValueMapper: (LineDefaultChartData data, _) =>
                        data.date.day,
                    yValueMapper: (LineDefaultChartData data, _) => data.total,
                    legendItemText: 'Total',
                    name: 'Total',
                    markerSettings: MarkerSettings(isVisible: true),
                    dataLabelSettings: const DataLabelSettings(
                        // Renders the data label
                        isVisible: false)),
                LineSeries<LineDefaultChartData, int>(
                    dataSource: chartData,
                    color: Colors.amberAccent,
                    xValueMapper: (LineDefaultChartData data, _) =>
                        data.date.day,
                    yValueMapper: (LineDefaultChartData data, _) =>
                        data.completed,
                    legendItemText: 'Done',
                    name: 'Done',
                    markerSettings: MarkerSettings(isVisible: true),
                    dataLabelSettings: const DataLabelSettings(
                        // Renders the data label
                        isVisible: false)),
              ],
            );
          } else {
            return Container();
          }
        });
  }
}

class LineDefaultChartData {
  final DateTime date;
  final int total;
  final int completed;
  LineDefaultChartData(this.date, this.total, this.completed);
}
