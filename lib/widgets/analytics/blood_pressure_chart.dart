import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/reading_controller.dart';
import 'package:heartless/services/enums/medical_reading_type.dart';
import 'package:heartless/shared/models/reading.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BloodPressureChart extends StatelessWidget {
  final String patientId;
  final DateTime date;
  const BloodPressureChart(
      {super.key, required this.patientId, required this.date});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 350,
      child: StreamBuilder(
        stream: ReadingController.getAllReadingsOfTheWeek(date, patientId),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data.docs.isNotEmpty) {
            List<BloodPressureChartData> chartData = [];
            snapshot.data.docs.forEach((readingSnapshot) {
              Reading reading = Reading.fromMap(readingSnapshot.data());
              if (reading.type == MedicalReadingType.bloodPressure) {
                chartData.add(BloodPressureChartData(
                    reading.time, reading.value, reading.optionalValue ?? 0));
              }
            });
            return SfCartesianChart(
              title: ChartTitle(text: 'Blood Pressure'),
              primaryXAxis: DateTimeAxis(), // todo: have to check how it looks
              primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: 200,
                interval: 20,
              ),
              legend: Legend(isVisible: true, position: LegendPosition.bottom),
              series: <CartesianSeries>[
                LineSeries<BloodPressureChartData, DateTime>(
                  dataSource: chartData,
                  legendItemText: 'Systolic',
                  name: 'Systolic',
                  color: Colors.amber,
                  xValueMapper: (BloodPressureChartData data, _) =>
                      data.dateTime,
                  yValueMapper: (BloodPressureChartData data, _) =>
                      data.systolic,
                  // onCreateShader: (ShaderDetails details) {
                  //   return ui.Gradient.linear(details.rect.topCenter,
                  //       details.rect.bottomCenter, <Color>[
                  //     const Color.fromRGBO(4, 8, 195, 1),
                  //     const Color.fromRGBO(4, 8, 195, 1),
                  //     const Color.fromRGBO(26, 112, 23, 1),
                  //     const Color.fromRGBO(26, 112, 23, 1),
                  //     const Color.fromRGBO(229, 11, 10, 1),
                  //     const Color.fromRGBO(229, 11, 10, 1),
                  //   ], <double>[
                  //     0,
                  //     0.333333,
                  //     0.333333,
                  //     0.666666,
                  //     0.666666,
                  //     0.999999,
                  //   ]);
                  // },
                ),
                LineSeries<BloodPressureChartData, DateTime>(
                  dataSource: chartData,
                  legendItemText: 'Diastolic',
                  name: 'Diastolic',
                  color: Colors.red,
                  xValueMapper: (BloodPressureChartData data, _) =>
                      data.dateTime,
                  yValueMapper: (BloodPressureChartData data, _) =>
                      data.diastolic,
                  // onCreateShader: (ShaderDetails details) {
                  //   return ui.Gradient.linear(details.rect.topCenter,
                  //       details.rect.bottomCenter, <Color>[
                  //     const Color.fromRGBO(4, 8, 195, 1),
                  //     const Color.fromRGBO(4, 8, 195, 1),
                  //     const Color.fromRGBO(26, 112, 23, 1),
                  //     const Color.fromRGBO(26, 112, 23, 1),
                  //     const Color.fromRGBO(229, 11, 10, 1),
                  //     const Color.fromRGBO(229, 11, 10, 1),
                  //   ], <double>[
                  //     0,
                  //     0.333333,
                  //     0.333333,
                  //     0.666666,
                  //     0.666666,
                  //     0.999999,
                  //   ]);
                  // },
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class BloodPressureChartData {
  final DateTime dateTime;
  final double systolic;
  final double diastolic;

  BloodPressureChartData(this.dateTime, this.systolic, this.diastolic);
}
