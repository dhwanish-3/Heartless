enum ActivityStatus { completed, upcoming, missed }

// Convert ActivityStatus enum to String
extension ActivityStatusExtension on ActivityStatus {
  String get name {
    switch (this) {
      case ActivityStatus.completed:
        return 'Completed';
      case ActivityStatus.upcoming:
        return 'Upcoming';
      case ActivityStatus.missed:
        return 'Missed';
      default:
        return 'Unknown';
    }
  }

  String get icon {
    switch (this) {
      case ActivityStatus.completed:
        return 'assets/Icons/reminder/tick.png';
      case ActivityStatus.upcoming:
        return 'assets/Icons/reminder/bell.png';
      case ActivityStatus.missed:
        return 'assets/Icons/reminder/wrong.png';
      default:
        return 'assets/Icons/reminder/tick.png';
    }
  }

  String? get completionStatusIcon {
    switch (this) {
      case ActivityStatus.completed:
        return 'assets/Icons/reminder/tick.png';
      case ActivityStatus.missed:
        return 'assets/Icons/reminder/wrong.png';
      default:
        return null;
    }
  }
}
