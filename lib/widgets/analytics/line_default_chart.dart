import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/activity_controller.dart';
import 'package:heartless/services/date/date_service.dart';
import 'package:heartless/services/enums/activity_status.dart';
import 'package:heartless/services/enums/activity_type.dart';
import 'package:heartless/shared/models/activity.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineDefaultChart extends StatelessWidget {
  final String patientId;
  final ActivityType activityType;
  final DateTime date;
  LineDefaultChart(
      {super.key,
      required this.patientId,
      required this.activityType,
      required this.date});

  List<LineDefaultChartData> getDataFromSnapshot(AsyncSnapshot snapshot) {
    List<LineDefaultChartData> newChartData = [];
    if (snapshot.hasData &&
        snapshot.data != null &&
        snapshot.data.docs.isNotEmpty) {
      List<Activity> activities = [];
      snapshot.data.docs.forEach((activity) {
        if (activity.data()['type'] == activityType.index) {
          activities.add(Activity.fromMap(activity.data()));
        }
      });

      Map<DateTime, List<Activity>> activitiesMap = {};
      DateTime startOfTheWeek = DateService.getStartOfWeek(date);
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
    }
    return newChartData;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: ActivityController.getAllActivitiesForAWeek(date, patientId),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data.docs.isNotEmpty) {
            List<LineDefaultChartData> chartData =
                getDataFromSnapshot(snapshot);
            return SfCartesianChart(
              plotAreaBorderWidth: 0,
              title: ChartTitle(text: activityType.name),
              legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  overflowMode: LegendItemOverflowMode.wrap),
              primaryXAxis: DateTimeAxis(
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  intervalType: DateTimeIntervalType.days,
                  interval: 1,
                  dateFormat: DateFormat.d(),
                  name: "Date",
                  majorGridLines: MajorGridLines(width: 0)),
              primaryYAxis: NumericAxis(
                  interval: 1,
                  name: "Count",
                  majorTickLines: MajorTickLines(color: Colors.transparent)),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries>[
                LineSeries<LineDefaultChartData, DateTime>(
                    dataSource: chartData,
                    color: activityType.color,
                    xValueMapper: (LineDefaultChartData data, _) => data.date,
                    yValueMapper: (LineDefaultChartData data, _) => data.total,
                    legendItemText: 'Total',
                    name: 'Total',
                    markerSettings: MarkerSettings(isVisible: true),
                    dataLabelSettings: const DataLabelSettings(
                        // Renders the data label
                        isVisible: false)),
                LineSeries<LineDefaultChartData, DateTime>(
                    dataSource: chartData,
                    color: Colors.amberAccent,
                    xValueMapper: (LineDefaultChartData data, _) => data.date,
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
