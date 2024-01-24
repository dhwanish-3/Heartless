enum Status { completed, upcoming, missed }

enum Type { medicine, excercise, diet }

// Convert Status enum to String
String statusToString(Status status) {
  switch (status) {
    case Status.completed:
      return 'Completed';
    case Status.upcoming:
      return 'Upcoming';
    case Status.missed:
      return 'Missed';
    default:
      return 'Unknown';
  }
}

// Convert Type enum to String
String typeToString(Type type) {
  switch (type) {
    case Type.medicine:
      return 'Medicine';
    case Type.excercise:
      return 'Excercise';
    case Type.diet:
      return 'Diet';
    default:
      return 'Unknown';
  }
}

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
    time = map['time'].toDate(); // Convert Timestamp to DateTime
    description = map['description'];
    status = Status.values[map['status']];
    type = Type.values[map['type']];
    patientId = map['patientId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'time': time, // Convert DateTime to Timestamp done by Firestore
      'description': description,
      'status': status.index,
      'type': type.index,
      'patientId': patientId,
    };
  }
}
