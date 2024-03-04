import 'package:heartless/services/enums/activity_status.dart';
import 'package:heartless/services/enums/activity_type.dart';
import 'package:heartless/shared/models/activity.dart';

const userId = '1';

List<Map<String, dynamic>> activitiesJSON = [
  {
    'id': '1',
    'name': 'Paracetamol',
    'time': DateTime.now().add(const Duration(hours: 1)),
    'description': 'Take medicine',
    'ActivityStatus': ActivityStatus.upcoming.index,
    'ActivityType': ActivityType.medicine.index,
    'patientId': userId,
  },
  {
    'id': '2',
    'name': 'Morning walk',
    'time': DateTime.now().add(const Duration(hours: 2)),
    'description': 'Morning walk for 30 minutes',
    'ActivityStatus': ActivityStatus.upcoming.index,
    'ActivityType': ActivityType.excercise.index,
    'patientId': userId,
  },
  {
    'id': '3',
    'name': 'Breakfast',
    'time': DateTime.now().add(const Duration(hours: 3)),
    'description': 'Eat healthy breakfast',
    'ActivityStatus': ActivityStatus.upcoming.index,
    'ActivityType': ActivityType.diet.index,
    'patientId': userId,
  },
  {
    'id': '4',
    'name': 'Rest',
    'time': DateTime.now().add(const Duration(hours: 4)),
    'description': 'Take rest for 30 minutes',
    'ActivityStatus': ActivityStatus.upcoming.index,
    'ActivityType': ActivityType.excercise.index,
    'patientId': userId,
  }
];

List<Activity> getActivities() {
  List<Activity> activitiesList = [];
  for (var element in activitiesJSON) {
    activitiesList.add(Activity.fromMap(element));
  }
  return activitiesList;
}

List<Activity> activities = getActivities();
