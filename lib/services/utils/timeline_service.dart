import 'dart:ui';

import 'package:heartless/backend/controllers/activity_controller.dart';
import 'package:heartless/backend/controllers/reading_controller.dart';
import 'package:heartless/services/enums/activity_status.dart';
import 'package:heartless/services/enums/activity_type.dart';
import 'package:heartless/services/enums/medical_reading_type.dart';

class TimeLineService {
  static Future<List<TimeLineData>> getTimeLine(
      String patientId, int limit) async {
    List<TimeLineData> timeLineList = [];
    await ReadingController.getAllReadingsOfTheWeekAsList(
            DateTime.now(), patientId,
            limit: limit)
        .then((value) {
      value.forEach((reading) {
        timeLineList.add(TimeLineData(
            title: 'Reading Added ' +
                reading.type.formatReading(reading.value.toString(),
                    reading.optionalValue.toString()) +
                reading.unit,
            tag: reading.type.tag,
            color: reading.type.color,
            date: reading.time));
      });
    });

    await ActivityController.getAllActivitiesOfTheWeekAsList(
            DateTime.now(), patientId,
            limit: limit)
        .then((value) {
      value.forEach((activity) {
        if (activity.status == ActivityStatus.completed) {
          timeLineList.add(TimeLineData(
              title: 'Activity Completed ' + activity.name,
              tag: activity.type.name,
              color: activity.type.color,
              date: activity.time));
        }
      });
    });

    timeLineList.sort((b, a) => a.date.compareTo(b.date));
    // resize the list to the limit
    if (timeLineList.length > limit) {
      timeLineList = timeLineList.sublist(0, limit);
    }
    return timeLineList;
  }
}

class TimeLineData {
  final String title;
  final DateTime date;
  final String tag;
  final Color color;

  TimeLineData(
      {required this.title,
      required this.date,
      required this.tag,
      required this.color});
}
