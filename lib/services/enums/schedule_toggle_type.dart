import 'package:heartless/services/enums/activity_type.dart';

enum ScheduleToggleType { all, medicine, diet, drill }

extension ScheduleToggleTypeExtension on ScheduleToggleType {
  String get name {
    switch (this) {
      case ScheduleToggleType.all:
        return 'All';
      case ScheduleToggleType.medicine:
        return 'Medicine';
      case ScheduleToggleType.diet:
        return 'Diet';
      case ScheduleToggleType.drill:
        return 'Drill';
      default:
        return 'Unknown';
    }
  }

  ActivityType get type {
    switch (this) {
      case ScheduleToggleType.medicine:
        return ActivityType.medicine;
      case ScheduleToggleType.diet:
        return ActivityType.diet;
      case ScheduleToggleType.drill:
        return ActivityType.exercise;
      default:
        return ActivityType.medicine;
    }
  }

  String get title {
    switch (this) {
      case ScheduleToggleType.all:
        return 'ALL';
      case ScheduleToggleType.medicine:
        return 'MED';
      case ScheduleToggleType.diet:
        return 'DIET';
      case ScheduleToggleType.drill:
        return 'DRILL';
      default:
        return 'Unknown';
    }
  }
}
