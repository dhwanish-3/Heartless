import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/activity_controller.dart';
import 'package:heartless/services/date/date_service.dart';
import 'package:heartless/services/enums/activity_status.dart';
import 'package:heartless/shared/models/activity.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StackedColumnChart extends StatefulWidget {
  final String patientId;
  const StackedColumnChart({super.key, required this.patientId});

  @override
  State<StackedColumnChart> createState() => _StackedColumnChartState();
}

class _StackedColumnChartState extends State<StackedColumnChart> {
  @override
  Widget build(BuildContext context) {
    List<StackedColumnChartData> chartData = [];
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
            activitiesMap[DateService.getStartOfDay(activity.time)] = [
              activity
            ];
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
          chartData.add(StackedColumnChartData(map.key, total, completed));
        }
      }
    }

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
                            primaryXAxis: CategoryAxis(),
                            series: <CartesianSeries>[
                              StackedColumnSeries<StackedColumnChartData, int>(
                                dataSource: chartData,
                                xValueMapper:
                                    (StackedColumnChartData data, _) =>
                                        data.date.day,
                                yValueMapper:
                                    (StackedColumnChartData data, _) =>
                                        data.total,
                                dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    showCumulativeValues: true,
                                    textStyle: TextStyle(fontSize: 17)),
                              ),
                              StackedColumnSeries<StackedColumnChartData, int>(
                                dataSource: chartData,
                                xValueMapper:
                                    (StackedColumnChartData data, _) =>
                                        data.date.day,
                                yValueMapper:
                                    (StackedColumnChartData data, _) =>
                                        data.completed,
                                dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    showCumulativeValues: true,
                                    textStyle: TextStyle(fontSize: 15)),
                              ),
                            ]);
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }))));
  }
}

class StackedColumnChartData {
  final DateTime date;
  final int total;
  final int completed;
  StackedColumnChartData(this.date, this.total, this.completed);
}
