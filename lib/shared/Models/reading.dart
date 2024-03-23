import 'package:heartless/services/enums/medical_reading_type.dart';

class Reading {
  String id = '';
  DateTime time = DateTime.now();
  double value = 0;
  String unit = '';
  String? comment;
  double? optionalValue;
  MedicalReadingType type = MedicalReadingType.heartRate;
  String patientId = '';

  Reading(
      {required this.time,
      required this.value,
      required this.unit,
      this.comment = '',
      required this.type,
      required this.patientId,
      this.optionalValue = 0});

  Reading.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    time = map['time'].toDate(); // Convert Timestamp to DateTime
    value = map['value'];
    optionalValue = map['optionalValue'];
    unit = map['unit'];
    comment = map['comment'];
    type = MedicalReadingType.values[map['type']];
    patientId = map['patientId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time, // Convert DateTime to Timestamp done by Firestore
      'value': value,
      'unit': unit,
      'comment': comment,
      'optionalValue': optionalValue,
      'type': type.index,
      'patientId': patientId,
    };
  }
}
