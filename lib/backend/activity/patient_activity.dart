import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heartless/shared/Models/activity.dart';

class PatientActivity {
  String patientId = '';
  var _fireStore = FirebaseFirestore.instance.collection('Patients');

  PatientActivity(String id) {
    patientId = id;
    _fireStore = FirebaseFirestore.instance
        .collection('Patients')
        .doc(id)
        .collection('Activities');
  }

  // mark as completed
  Future<bool> markAsCompleted(String activityId) async {
    try {
      await _fireStore
          .doc(activityId)
          .update({'status': Status.completed.index});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // to add an activity
  Future<Activity> addActivity(Activity activity) async {
    try {
      // get a new id
      DocumentReference documentReference = _fireStore.doc();
      activity.id = documentReference.id;
      await documentReference.set(activity.toMap());
      return activity;
    } catch (e) {
      print(e);
      return Activity();
    }
  }

  // to get all activities
  Future<List<Activity>> getAllActivities(String patientId) async {
    try {
      QuerySnapshot querySnapshot =
          await _fireStore.where('patientId', isEqualTo: patientId).get();
      List<Activity> activities = [];
      for (var element in querySnapshot.docs) {
        activities
            .add(Activity.fromMap(element.data() as Map<String, dynamic>));
      }
      return activities;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // to get update the activity status according to the time
  Future<bool> updateActivityStatus() async {
    try {
      QuerySnapshot querySnapshot = await _fireStore
          .where('status', isEqualTo: Status.upcoming.index)
          .get();
      for (var element in querySnapshot.docs) {
        Activity activity =
            Activity.fromMap(element.data() as Map<String, dynamic>);
        if (activity.time.isBefore(DateTime.now())) {
          await _fireStore
              .doc(element.id)
              .update({'status': Status.missed.index});
        }
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // to get all upcoming activities
  Future<List<Activity>> getUpcomingActivities(String patientId) async {
    try {
      QuerySnapshot querySnapshot = await _fireStore
          .where('patientId', isEqualTo: patientId)
          .where('status', isEqualTo: Status.upcoming.index)
          .get();
      List<Activity> activities = [];
      for (var element in querySnapshot.docs) {
        activities
            .add(Activity.fromMap(element.data() as Map<String, dynamic>));
      }
      return activities;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
