import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heartless/shared/models/activity.dart';

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

  // to get start of the week of a given date
  DateTime getStartOfWeekOfDate(DateTime date) {
    DateTime startOfWeek = date;
    startOfWeek = startOfWeek.subtract(Duration(days: startOfWeek.weekday - 1));
    startOfWeek = DateTime(
        startOfWeek.year, startOfWeek.month, startOfWeek.day, 0, 0, 0, 0, 0);
    return startOfWeek;
  }

  // to get start of the day
  DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 0, 0, 0, 0, 0);
  }

  // mark as completed
  Future<bool> markAsCompleted(String activityId) async {
    // activity can be marked as completed only if it belongs to the current week
    DateTime startOfWeek = getStartOfWeekOfDate(DateTime.now());
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
      DateTime startOfWeek = getStartOfWeekOfDate(activity.time);
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

  // to edit an activity
  Future<bool> editActivity(Activity activity) async {
    try {
      if (activity.id == '') {
        return false;
      }
      DateTime startOfWeek = getStartOfWeekOfDate(activity.time);
      await _fireStore
          .doc(startOfWeek.toString())
          .collection('Activities')
          .doc(activity.id)
          .update(activity.toMap());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // to get all activities of the day
  Future<List<Activity>> getAllActivitiesOfTheDate(DateTime date) async {
    try {
      DateTime startOfWeek = getStartOfWeekOfDate(date);
      DateTime startOfDay = getStartOfDay(date);

      QuerySnapshot querySnapshot = await _fireStore
          .doc(startOfWeek.toString())
          .collection('Activities')
          .where('time', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('time',
              isLessThan:
                  Timestamp.fromDate(startOfDay.add(const Duration(days: 1))))
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
    DateTime startOfWeek = getStartOfWeekOfDate(DateTime.now());

    try {
      // get all the activities with status upcoming
      QuerySnapshot querySnapshot = await _fireStore
          .doc(startOfWeek.toString())
          .collection('Activities')
          .where('status', isEqualTo: Status.upcoming.index)
          .where('time',
              isLessThan: Timestamp.fromDate(DateTime.now().add(const Duration(
                  minutes: -10)))) //! giving a buffer time of 10 minutes
          .get();

      // check if the time of the activity is before the current time
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
  Future<List<Activity>> getCompletedActivitiesOftheDay(
      DateTime dateTime) async {
    DateTime startOfWeek = getStartOfWeekOfDate(dateTime);
    DateTime startOfDay = getStartOfDay(dateTime);
    try {
      QuerySnapshot querySnapshot = await _fireStore
          .doc(startOfWeek.toString())
          .collection('Activities')
          .where('time', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('time',
              isLessThan:
                  Timestamp.fromDate(startOfDay.add(const Duration(days: 1))))
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
  Future<List<Activity>> getUpcomingActivitiesOftheDay(
      DateTime dateTime) async {
    DateTime startOfWeek = getStartOfWeekOfDate(dateTime);
    DateTime startOfDay = getStartOfDay(dateTime);
    try {
      QuerySnapshot querySnapshot = await _fireStore
          .doc(startOfWeek.toString())
          .collection('Activities')
          .where('time', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('time',
              isLessThan:
                  Timestamp.fromDate(startOfDay.add(const Duration(days: 1))))
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
  Future<List<Activity>> getMissedActivitiesOftheDay(DateTime dateTime) async {
    DateTime startOfWeek = getStartOfWeekOfDate(dateTime);
    DateTime startOfDay = getStartOfDay(dateTime);
    try {
      QuerySnapshot querySnapshot = await _fireStore
          .doc(startOfWeek.toString())
          .collection('Activities')
          .where('time', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('time',
              isLessThan:
                  Timestamp.fromDate(startOfDay.add(const Duration(days: 1))))
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
