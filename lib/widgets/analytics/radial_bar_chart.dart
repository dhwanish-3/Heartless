import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/activity_controller.dart';
import 'package:heartless/services/enums/activity_status.dart';
import 'package:heartless/services/enums/activity_type.dart';
import 'package:heartless/shared/models/activity.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RadialBarChart extends StatelessWidget {
  final String patientId;
  final DateTime date;
  const RadialBarChart(
      {super.key, required this.patientId, required this.date});

  List<RadialChartData> getDataFromSnapshot(AsyncSnapshot snapshot) {
    List<RadialChartData> newChartData = [];
    if (snapshot.hasData &&
        snapshot.data != null &&
        snapshot.data.docs.isNotEmpty) {
      List<Activity> activities = [];
      snapshot.data.docs.forEach((activity) {
        activities.add(Activity.fromMap(activity.data()));
      });

      Map<ActivityType, List<Activity>> activitiesMap = {};
      activitiesMap[ActivityType.medicine] = [];
      activitiesMap[ActivityType.exercise] = [];
      activitiesMap[ActivityType.diet] = [];
      activities.forEach((activity) {
        if (activity.time.isBefore(date))
          activitiesMap[activity.type]!.add(activity);
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
        newChartData.add(RadialChartData(
            map.key.name, (completed / total) * 100, map.key.color));
      }
    }
    return newChartData;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: StreamBuilder(
          stream: ActivityController.getAllActivitiesForAWeek(date, patientId),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data.docs.isNotEmpty) {
              List<RadialChartData> radialChartData =
                  getDataFromSnapshot(snapshot);
              return SfCircularChart(
                  tooltipBehavior: TooltipBehavior(enable: true),
                  title: ChartTitle(text: 'Activity Completion'),
                  legend: Legend(
                      isVisible: true,
                      overflowMode: LegendItemOverflowMode.wrap),
                  series: <CircularSeries>[
                    RadialBarSeries<RadialChartData, String>(
                        strokeColor: Colors.white,
                        radius: "80",
                        innerRadius: "25",
                        // trackBorderWidth: 0,
                        dataSource: radialChartData,
                        pointColorMapper: (datum, index) => datum.color,
                        xValueMapper: (RadialChartData data, _) => data.name,
                        yValueMapper: (RadialChartData data, _) => data.value,
                        cornerStyle: CornerStyle.bothCurve,
                        maximumValue: 100,
                        dataLabelSettings: const DataLabelSettings(
                            // Renders the data label
                            // isVisible: true,
                            textStyle: TextStyle(fontSize: 15)))
                  ]);
            } else {
              return Container();
            }
          }),
    );
  }
}

class RadialChartData {
  final Color color;
  final String name;
  final double value;
  RadialChartData(this.name, this.value, this.color);
}
