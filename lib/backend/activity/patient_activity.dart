import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heartless/shared/Models/activity.dart';

class PatientActivity {
  String patientId = '';
  var _fireStore = FirebaseFirestore.instance
      .collection('Patients'); // *fake(not used) initializing

  PatientActivity(String id) {
    patientId = id;
    _fireStore = FirebaseFirestore.instance
        .collection('Patients')
        .doc(id)
        .collection(
            'WeeklyData'); //! updating the collection NOTE: this is the definition actually used for _fireStore
  }

  // to get start of the week
  DateTime getStartOfWeek() {
    DateTime startOfWeek = DateTime.now();
    startOfWeek = startOfWeek.subtract(Duration(days: startOfWeek.weekday - 1));
    startOfWeek = DateTime(
        startOfWeek.year, startOfWeek.month, startOfWeek.day, 0, 0, 0, 0, 0);
    return startOfWeek;
  }

  // to get start of the day
  DateTime getStartOfDay(DateTime startOfDay) {
    startOfDay = DateTime(
        startOfDay.year, startOfDay.month, startOfDay.day, 0, 0, 0, 0, 0);
    return startOfDay;
  }

  // mark as completed
  Future<bool> markAsCompleted(String activityId) async {
    DateTime startOfWeek = getStartOfWeek();
    try {
      await _fireStore
          .doc(startOfWeek.toString())
          .collection('Activities')
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
      DateTime startOfWeek = getStartOfWeek();
      DocumentReference documentReference =
          _fireStore.doc(startOfWeek.toString()).collection('Activities').doc();
      // getting the id for the new activity
      activity.id = documentReference.id;
      await documentReference.set(activity.toMap());
      return activity;
    } catch (e) {
      print(e);
      return Activity();
    }
  }

  // to get all activities of the day
  Future<List<Activity>> getAllActivitiesOfTheDay(DateTime date) async {
    try {
      DateTime startOfWeek = getStartOfWeek();
      date = getStartOfDay(date);
      QuerySnapshot querySnapshot = await _fireStore
          .doc(startOfWeek.toString())
          .collection('Activities')
          .where('time', isGreaterThanOrEqualTo: date)
          .where('time', isLessThan: date.add(const Duration(days: 1)))
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

  // to get update the activity status according to the time
  Future<bool> updateActivityStatus() async {
    // get the Datetime with for the start of the week
    DateTime startOfWeek = getStartOfWeek();

    try {
      // get all the activities with status upcoming
      QuerySnapshot querySnapshot = await _fireStore
          .doc(startOfWeek.toString())
          .collection('Activities')
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

  // to get all completed activities of the day
  Future<List<Activity>> getCompletedActivitiesOftheDay() async {
    DateTime startOfWeek = getStartOfWeek();
    try {
      QuerySnapshot querySnapshot = await _fireStore
          .doc(startOfWeek.toString())
          .collection('Activities')
          .where('status', isEqualTo: Status.completed.index)
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

  // to get all upcoming activities of the day
  Future<List<Activity>> getUpcomingActivitiesOftheDay() async {
    DateTime startOfWeek = getStartOfWeek();
    try {
      QuerySnapshot querySnapshot = await _fireStore
          .doc(startOfWeek.toString())
          .collection('Activities')
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

  // to get all missed activities of the day
  Future<List<Activity>> getMissedActivitiesOftheDay() async {
    DateTime startOfWeek = getStartOfWeek();
    try {
      QuerySnapshot querySnapshot = await _fireStore
          .doc(startOfWeek.toString())
          .collection('Activities')
          .where('status', isEqualTo: Status.missed.index)
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
