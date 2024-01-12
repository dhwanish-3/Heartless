enum Status { completed, upcoming, missed }

enum Type { medicine, excercise, diet }

class Activity {
  String name = '';
  DateTime time = DateTime.now();
  String description = '';
  Status status = Status.upcoming;
  Type type = Type.medicine;

  Activity();

  Activity.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    time = DateTime.parse(map['time']);
    description = map['description'];
    status = Status.values[map['status']];
    type = Type.values[map['type']];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'time': time.toString(),
      'description': description,
      'status': status.index,
      'type': type.index,
    };
  }
}
