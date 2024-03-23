enum ReadingType {
  heartRate,
  bodyTemperature,
  bloodPressure,
  bloodOxygen,
  weight,
  height,
  glucose,
  cholesterol,
  other
}

class Reading {
  String id = '';
  DateTime time = DateTime.now();
  double value = 0;
  String unit = '';
  String? comment;
  double? optionalValue;
  ReadingType type = ReadingType.heartRate;
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
    //todo optionalValue
    unit = map['unit'];
    comment = map['comment'];
    type = ReadingType.values[map['type']];
    patientId = map['patientId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time, // Convert DateTime to Timestamp done by Firestore
      'value': value,
      'unit': unit,
      'comment': comment,
      'type': type.index,
      'patientId': patientId,
    };
  }
}
