import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/reading_controller.dart';
import 'package:heartless/services/enums/medical_reading_type.dart';
import 'package:heartless/shared/models/reading.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BloodPressureChart extends StatelessWidget {
  final String patientId;
  final DateTime date;

  const BloodPressureChart({
    super.key,
    required this.patientId,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
          // sort charData by dateTime
          chartData.sort((a, b) => a.dateTime.compareTo(b.dateTime));
          if (chartData.length > 1) {
            return SfCartesianChart(
              title: ChartTitle(text: 'Blood Pressure'),
              primaryXAxis: DateTimeAxis(), // todo: have to check how it looks
              primaryYAxis: NumericAxis(),
              tooltipBehavior: TooltipBehavior(enable: true),
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
                ),
              ],
            );
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }
}

class BloodPressureChartData {
  final DateTime dateTime;
  final double systolic;
  final double diastolic;

  BloodPressureChartData(this.dateTime, this.systolic, this.diastolic);
}
