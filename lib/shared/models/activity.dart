import 'package:heartless/services/enums/activity_status.dart';
import 'package:heartless/services/enums/activity_type.dart';

class Activity {
  String id = '';
  String name = '';
  DateTime time = DateTime.now();
  String description = '';
  ActivityStatus status = ActivityStatus.upcoming;
  ActivityType type = ActivityType.medicine;
  String patientId = '';

  Activity();

  Activity.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    time = map['time'].toDate(); // Convert Timestamp to DateTime
    description = map['description'];
    status = ActivityStatus.values[map['status']];
    type = ActivityType.values[map['type']];
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
