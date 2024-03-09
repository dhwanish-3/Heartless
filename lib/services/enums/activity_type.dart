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
        return Colors.blue;
      case ActivityType.excercise:
        return Colors.green;
      case ActivityType.diet:
        return Colors.red;
      default:
        return Colors.black;
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
