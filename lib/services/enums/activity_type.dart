enum ActivityType { medicine, diet, excercise }

extension TypeExtension on ActivityType {
  String get name {
    switch (this) {
      case ActivityType.medicine:
        return 'Medicine';
      case ActivityType.excercise:
        return 'Excercise';
      case ActivityType.diet:
        return 'Diet';
      default:
        return 'Unknown';
    }
  }
}