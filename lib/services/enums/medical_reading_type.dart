import 'package:flutter/material.dart';

enum MedicalReadingType {
  heartRate,
  bloodPressure,
  weight,
  glucose,
  other,
  waterConsumption,
  sleep,
  distanceWalked,
  caloriesBurned,
  steps,
  exerciseDuration,
  sodiumIntake,
  transFatIntake,
  sugarIntake,
  diary,
}

extension MedicalReadingTypeExtension on MedicalReadingType {
  String get tag {
    switch (this) {
      case MedicalReadingType.heartRate:
        return 'Heart Rate';
      case MedicalReadingType.bloodPressure:
        return 'Blood Pressure';
      case MedicalReadingType.weight:
        return 'Weight';
      case MedicalReadingType.glucose:
        return 'Glucose';
      case MedicalReadingType.other:
        return 'Other';
      case MedicalReadingType.waterConsumption:
        return 'Water Consumption';
      case MedicalReadingType.sleep:
        return 'Sleep';
      case MedicalReadingType.distanceWalked:
        return 'Distance Walked';
      case MedicalReadingType.caloriesBurned:
        return 'Calories Burned';
      case MedicalReadingType.steps:
        return 'Steps';
      case MedicalReadingType.exerciseDuration:
        return 'Exercise Duration';
      case MedicalReadingType.sodiumIntake:
        return 'Sodium Intake';
      case MedicalReadingType.transFatIntake:
        return 'Trans Fat Intake';
      case MedicalReadingType.sugarIntake:
        return 'Sugar Intake';
      case MedicalReadingType.diary:
        return 'Diary';
      default:
        return '';
    }
  }

  String get icon {
    switch (this) {
      case MedicalReadingType.heartRate:
        return 'assets/Icons/readingGenre/heartRate.png';
      case MedicalReadingType.bloodPressure:
        return 'assets/Icons/readingGenre/bloodPressure.png';
      case MedicalReadingType.weight:
        return 'assets/Icons/readingGenre/weight.png';
      case MedicalReadingType.glucose:
        return 'assets/Icons/readingGenre/diabetes.png';
      case MedicalReadingType.other:
        return 'assets/Icons/readingGenre/other.png';
      case MedicalReadingType.diary:
        return 'assets/Icons/readingGenre/diary.png';
      default:
        return 'assets/Icons/readingGenre/other.png';
    }
  }

  Color get color {
    switch (this) {
      case MedicalReadingType.heartRate:
        return Colors.pink.shade200;
      case MedicalReadingType.bloodPressure:
        return Colors.blue.shade200;
      case MedicalReadingType.weight:
        return Colors.green.shade200;
      case MedicalReadingType.glucose:
        return Colors.orange.shade200;
      case MedicalReadingType.other:
        return Colors.brown.shade200;
      case MedicalReadingType.waterConsumption:
        return Colors.teal.shade200;
      case MedicalReadingType.sleep:
        return Colors.indigo.shade200;
      case MedicalReadingType.distanceWalked:
        return Colors.yellow.shade200;
      case MedicalReadingType.caloriesBurned:
        return Colors.red.shade200;
      case MedicalReadingType.steps:
        return Colors.deepPurple.shade200;
      case MedicalReadingType.exerciseDuration:
        return Colors.amber.shade200;
      case MedicalReadingType.sodiumIntake:
        return Colors.lightBlue.shade200;
      case MedicalReadingType.transFatIntake:
        return Colors.lime.shade200;
      case MedicalReadingType.sugarIntake:
        return Colors.deepOrange.shade200;
      case MedicalReadingType.diary:
        return Colors.deepOrangeAccent.shade200;
      default:
        return Colors.grey.shade200;
    }
  }

  String get unit {
    switch (this) {
      case MedicalReadingType.heartRate:
        return 'bpm';
      case MedicalReadingType.bloodPressure:
        return 'mmHg';
      case MedicalReadingType.weight:
        return 'kg';
      case MedicalReadingType.glucose:
        return 'mg/dL';
      case MedicalReadingType.other:
        return 'L'; //the default value of other is waterConsumption
      case MedicalReadingType.waterConsumption:
        return 'L';
      case MedicalReadingType.sleep:
        return 'hours';
      case MedicalReadingType.sugarIntake:
        return 'g';
      case MedicalReadingType.transFatIntake:
        return 'g';
      case MedicalReadingType.sodiumIntake:
        return 'mg';
      default:
        return '';
    }
  }

  String get hintText {
    switch (this) {
      case MedicalReadingType.heartRate:
        return '72 bpm';
      case MedicalReadingType.bloodPressure:
        return '120/80 mmHg';
      case MedicalReadingType.weight:
        return '65 kg';
      case MedicalReadingType.glucose:
        return '100 mg/dL';
      case MedicalReadingType.distanceWalked:
        return '0.5 km';
      case MedicalReadingType.caloriesBurned:
        return '200 kcal';
      case MedicalReadingType.steps:
        return '10000 steps';
      case MedicalReadingType.waterConsumption:
        return '2 L';
      case MedicalReadingType.exerciseDuration:
        return '30 minutes';
      case MedicalReadingType.sodiumIntake:
        return '2000 mg';
      case MedicalReadingType.transFatIntake:
        return '0 g';
      case MedicalReadingType.sugarIntake:
        return '50 g';
      default:
        return '';
    }
  }

  String formatReading(String value, String optionalValue) {
    switch (this) {
      case MedicalReadingType.bloodPressure:
        int systolic = double.parse(value).toInt();
        int diastolic = double.parse(optionalValue).toInt();
        return '$systolic/${diastolic} mmHg';
      default:
        return value + ' ' + unit;
    }
  }
}
