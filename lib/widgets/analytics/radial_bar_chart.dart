import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/activity_controller.dart';
import 'package:heartless/services/enums/activity_status.dart';
import 'package:heartless/services/enums/activity_type.dart';
import 'package:heartless/shared/models/activity.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RadialBarChart extends StatefulWidget {
  final String patientId;
  const RadialBarChart({super.key, required this.patientId});

  @override
  State<RadialBarChart> createState() => _RadialBarChartState();
}

class _RadialBarChartState extends State<RadialBarChart> {
  List<RadialChartData> radialChartData = [];
  void getDataFromSnapshot(AsyncSnapshot snapshot) {
    if (snapshot.hasData &&
        snapshot.data != null &&
        snapshot.data.docs.isNotEmpty) {
      List<Activity> activities = [];
      snapshot.data.docs.forEach((activity) {
        activities.add(Activity.fromMap(activity.data()));
      });

      Map<ActivityType, List<Activity>> activitiesMap = {};
      activitiesMap[ActivityType.medicine] = [];
      activitiesMap[ActivityType.excercise] = [];
      activitiesMap[ActivityType.diet] = [];
      activities.forEach((activity) {
        activitiesMap[activity.type]!.add(activity);
      });

      List<RadialChartData> newChartData = [];
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
      radialChartData = newChartData;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SizedBox(
                height: 180,
                child: StreamBuilder(
                    stream: ActivityController.getAllActivitiesForAWeek(
                        DateTime.now(), widget.patientId),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData &&
                          snapshot.data != null &&
                          snapshot.data.docs.isNotEmpty) {
                        getDataFromSnapshot(snapshot);
                        return SfCircularChart(series: <CircularSeries>[
                          // Renders radial bar chart
                          RadialBarSeries<RadialChartData, String>(
                              strokeColor: Colors.white,
                              radius: "80",
                              dataSource: radialChartData,
                              pointColorMapper: (datum, index) => datum.color,
                              xValueMapper: (RadialChartData data, _) =>
                                  data.name,
                              yValueMapper: (RadialChartData data, _) =>
                                  data.value,
                              cornerStyle: CornerStyle.bothCurve,
                              maximumValue: 100,
                              dataLabelSettings: const DataLabelSettings(
                                  // Renders the data label
                                  // isVisible: true,
                                  textStyle: TextStyle(fontSize: 15)))
                        ]);
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }))));
  }
}

class RadialChartData {
  final Color color;
  final String name;
  final double value;
  RadialChartData(this.name, this.value, this.color);
}
