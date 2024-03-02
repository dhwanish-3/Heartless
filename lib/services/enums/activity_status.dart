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
}
