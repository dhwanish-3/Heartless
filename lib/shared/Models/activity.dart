enum Status { completed, upcoming, missed }

enum Type { medicine, excercise, diet }

class Activity {
  String id = '';
  String name = '';
  DateTime time = DateTime.now();
  String description = '';
  Status status = Status.upcoming;
  Type type = Type.medicine;
  String patientId = '';

  Activity();

  Activity.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    time = map['time'].toDate();
    description = map['description'];
    status = Status.values[map['status']];
    type = Type.values[map['type']];
    patientId = map['patientId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'time': time,
      'description': description,
      'status': status.index,
      'type': type.index,
      'patientId': patientId,
    };
  }
}
