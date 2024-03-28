import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/reading_controller.dart';
import 'package:heartless/services/enums/medical_reading_type.dart';
import 'package:heartless/shared/models/reading.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GeneralReadingChart extends StatelessWidget {
  final String patientId;
  final MedicalReadingType readingType;
  final DateTime date;
  static final emptyWidget = Container();

  const GeneralReadingChart({
    super.key,
    required this.patientId,
    required this.date,
    required this.readingType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 200,
      child: StreamBuilder(
        stream: ReadingController.getAllReadingsOfTheWeek(date, patientId),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data.docs.isNotEmpty) {
            List<GeneralReadingChartData> chartData = [];
            snapshot.data.docs.forEach((readingSnapshot) {
              Reading reading = Reading.fromMap(readingSnapshot.data());
              if (reading.type == readingType) {
                chartData
                    .add(GeneralReadingChartData(reading.time, reading.value));
              }
            });
            // sort charData by dateTime
            chartData.sort((a, b) => a.dateTime.compareTo(b.dateTime));

            if (chartData.length > 1) {
              return SfCartesianChart(
                  title: ChartTitle(text: readingType.tag),
                  primaryXAxis:
                      DateTimeAxis(), // todo: have to check how it looks
                  primaryYAxis: NumericAxis(),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  legend:
                      Legend(isVisible: true, position: LegendPosition.bottom),
                  series: <CartesianSeries>[
                    LineSeries<GeneralReadingChartData, DateTime>(
                      dataSource: chartData,
                      legendItemText: readingType.name,
                      name: readingType.name,
                      color: Colors.blue,
                      markerSettings: MarkerSettings(isVisible: true),
                      xValueMapper: (GeneralReadingChartData data, _) =>
                          data.dateTime,
                      yValueMapper: (GeneralReadingChartData data, _) =>
                          data.value,
                    ),
                  ]);
            } else {
              return emptyWidget;
            }
          } else {
            return emptyWidget;
          }
        },
      ),
    );
  }
}

class GeneralReadingChartData {
  final DateTime dateTime;
  final double value;
  GeneralReadingChartData(this.dateTime, this.value);
}
