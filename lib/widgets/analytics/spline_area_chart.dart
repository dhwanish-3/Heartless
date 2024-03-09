import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/activity_controller.dart';
import 'package:heartless/services/date/date_service.dart';
import 'package:heartless/services/enums/activity_status.dart';
import 'package:heartless/shared/models/activity.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SplineAreaChart extends StatefulWidget {
  final String patientId;
  const SplineAreaChart({super.key, required this.patientId});

  @override
  State<SplineAreaChart> createState() => _SplineAreaChartState();
}

class _SplineAreaChartState extends State<SplineAreaChart> {
  List<SplineAreaChartData> chartData = [];
  void getDataFromSnapshot(AsyncSnapshot snapshot) {
    if (snapshot.hasData &&
        snapshot.data != null &&
        snapshot.data.docs.isNotEmpty) {
      List<Activity> activities = [];
      snapshot.data.docs.forEach((activity) {
        activities.add(Activity.fromMap(activity.data()));
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
      List<SplineAreaChartData> newChartData = [];

      for (var map in activitiesMap.entries) {
        int total = 0;
        int completed = 0;
        map.value.forEach((activity) {
          total++;
          if (activity.status == ActivityStatus.completed) {
            completed++;
          }
        });
        newChartData.add(SplineAreaChartData(map.key, total, completed));
      }
      chartData = newChartData;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SizedBox(
                height: 300,
                width: 350,
                child: StreamBuilder(
                    stream: ActivityController.getAllActivitiesForAWeek(
                        DateTime.now(), widget.patientId),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData &&
                          snapshot.data != null &&
                          snapshot.data.docs.isNotEmpty) {
                        getDataFromSnapshot(snapshot);
                        return SfCartesianChart(
                          series: <CartesianSeries>[
                            SplineAreaSeries<SplineAreaChartData, int>(
                                dataSource: chartData,
                                xValueMapper: (SplineAreaChartData data, _) =>
                                    data.date.day,
                                yValueMapper: (SplineAreaChartData data, _) =>
                                    data.total,
                                legendItemText: 'Total',
                                dataLabelSettings: const DataLabelSettings(
                                    // Renders the data label
                                    isVisible: false)),
                            SplineAreaSeries<SplineAreaChartData, int>(
                                dataSource: chartData,
                                xValueMapper: (SplineAreaChartData data, _) =>
                                    data.date.day,
                                yValueMapper: (SplineAreaChartData data, _) =>
                                    data.completed,
                                legendItemText: 'Completed',
                                dataLabelSettings: const DataLabelSettings(
                                    // Renders the data label
                                    isVisible: false)),
                          ],
                          legend: Legend(
                              isVisible: true, offset: const Offset(20, -80)),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }))));
  }
}

class SplineAreaChartData {
  final DateTime date;
  final int total;
  final int completed;
  SplineAreaChartData(this.date, this.total, this.completed);
}
