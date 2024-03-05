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
  String comments = '';
  ReadingType type = ReadingType.heartRate;
  String patientId = '';

  Reading(
      {required this.time,
      required this.value,
      required this.unit,
      required this.comments,
      required this.type,
      required this.patientId});

  Reading.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    time = map['time'].toDate(); // Convert Timestamp to DateTime
    value = map['value'];
    unit = map['unit'];
    comments = map['comments'];
    type = ReadingType.values[map['type']];
    patientId = map['patientId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time, // Convert DateTime to Timestamp done by Firestore
      'value': value,
      'unit': unit,
      'comments': comments,
      'type': type.index,
      'patientId': patientId,
    };
  }
}
