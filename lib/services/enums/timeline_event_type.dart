import 'dart:ui';

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
}
