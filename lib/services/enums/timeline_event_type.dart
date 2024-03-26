import 'package:flutter/material.dart';
import 'package:heartless/pages/log/daywise_log.dart';
import 'package:heartless/pages/log/health_documents_page.dart';
import 'package:heartless/pages/schedule/schedule_page.dart';
import 'package:heartless/shared/models/app_user.dart';

enum TimeLineEventType { reading, activity, healthDocument }

extension TimeLineEventTypeExtension on TimeLineEventType {
  String get name {
    switch (this) {
      case TimeLineEventType.reading:
        return 'Reading';
      case TimeLineEventType.activity:
        return 'Activity';
      case TimeLineEventType.healthDocument:
        return 'Health Document';
    }
  }

  String get tag {
    switch (this) {
      case TimeLineEventType.reading:
        return 'Reading';
      case TimeLineEventType.activity:
        return 'Activity';
      case TimeLineEventType.healthDocument:
        return 'Health Document';
    }
  }

  Color get color {
    switch (this) {
      case TimeLineEventType.reading:
        return Color(0xFF2196F3);
      case TimeLineEventType.activity:
        return Color(0xFF4CAF50);
      case TimeLineEventType.healthDocument:
        return Color.fromARGB(255, 152, 76, 175);
    }
  }

  Widget route(AppUser user) {
    switch (this) {
      case TimeLineEventType.reading:
        return DayWiseLogPage(
          patient: user,
        );
      case TimeLineEventType.activity:
        return SchedulePage(
          patient: user,
        );
      case TimeLineEventType.healthDocument:
        return HealthDocumentsPage(
          patientId: user.uid,
        );
    }
  }
}
