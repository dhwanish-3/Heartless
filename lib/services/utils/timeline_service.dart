import 'package:heartless/backend/controllers/activity_controller.dart';
import 'package:heartless/backend/controllers/health_document_controller.dart';
import 'package:heartless/backend/controllers/reading_controller.dart';
import 'package:heartless/services/enums/activity_status.dart';
import 'package:heartless/services/enums/medical_reading_type.dart';
import 'package:heartless/services/enums/timeline_event_type.dart';

class TimeLineService {
  static Future<List<TimeLineData>> getTimeLine(
      String patientId, int? limit) async {
    List<TimeLineData> timeLineList = [];
    // getting readings
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
            tag: TimeLineEventType.reading,
            date: reading.time));
      });
    });

    // getting activities
    await ActivityController.getAllActivitiesOfTheWeekAsList(
            DateTime.now(), patientId,
            limit: limit)
        .then((value) {
      value.forEach((activity) {
        if (activity.status == ActivityStatus.completed) {
          timeLineList.add(TimeLineData(
              title: 'Activity Completed ' + activity.name,
              tag: TimeLineEventType.activity,
              date: activity.time));
        }
      });
    });

    // getting health document additions
    await HealthDocumentController.getHealthDocumentsList(patientId,
            limit: limit)
        .then((value) {
      value.forEach((healthDocument) {
        timeLineList.add(TimeLineData(
            title: 'Document Added ' + healthDocument.name,
            tag: TimeLineEventType.healthDocument,
            date: healthDocument.createdAt));
      });
    });

    // sort the list by date
    timeLineList.sort((b, a) => a.date.compareTo(b.date));

    if (limit == null) return timeLineList;
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
  final TimeLineEventType tag;

  TimeLineData({
    required this.title,
    required this.date,
    required this.tag,
  });
}
