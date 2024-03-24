import 'package:flutter/material.dart';

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

  Color get color {
    switch (this) {
      case ActivityType.medicine:
        return Color.fromARGB(255, 125, 171, 247);
      case ActivityType.excercise:
        return Color.fromARGB(191, 52, 168, 83);
      case ActivityType.diet:
        return Color.fromARGB(178, 255, 104, 56);
      default:
        return Color.fromARGB(255, 125, 171, 247);
    }
  }

  String get dropDownValue {
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

  String get icon {
    switch (this) {
      case ActivityType.medicine:
        return 'assets/Icons/readingGenre/heartRate.png';
      case ActivityType.excercise:
        return 'assets/Icons/readingGenre/bloodPressure.png';
      case ActivityType.diet:
        return 'assets/Icons/readingGenre/weight.png';
      default:
        return 'assets/Icons/readingGenre/other.png';
    }
  }

  String get imageUrl {
    switch (this) {
      case ActivityType.medicine:
        return 'assets/Icons/reminder/medicine.png';
      case ActivityType.excercise:
        return 'assets/Icons/reminder/exercise.png';
      case ActivityType.diet:
        return 'assets/Icons/reminder/food.png';
      default:
        return 'assets/Icons/readingGenre/other.png';
    }
  }
}

ActivityType activityFromString(String value) {
  switch (value) {
    case 'Medicine':
      return ActivityType.medicine;
    case 'Excercise':
      return ActivityType.excercise;
    case 'Diet':
      return ActivityType.diet;

    default:
      return ActivityType.medicine;
  }
}
