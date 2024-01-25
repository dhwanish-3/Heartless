import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heartless/services/exceptions/app_exceptions.dart';
import 'package:heartless/shared/models/activity.dart';

class ActivityService {
  final _uid = FirebaseAuth.instance.currentUser!.uid;
  var _fireStore = FirebaseFirestore.instance
      .collection('Patients'); // *fake(not used) initializing

  static const Duration _timeLimit = Duration(seconds: 10);

  ActivityService() {
    _fireStore = FirebaseFirestore.instance
        .collection('Patients')
        .doc(_uid)
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
          .update({'status': Status.completed.index}).timeout(_timeLimit);
      return true;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
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
      await documentReference.set(activity.toMap()).timeout(_timeLimit);
      return activity;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
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
          .update(activity.toMap())
          .timeout(_timeLimit);
      return true;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // to delete an activity
  Future<bool> deleteActivity(Activity activity) async {
    try {
      if (activity.id == '') {
        return false;
      }
      DateTime startOfWeek = getStartOfWeekOfDate(activity.time);
      await _fireStore
          .doc(startOfWeek.toString())
          .collection('Activities')
          .doc(activity.id)
          .delete()
          .timeout(_timeLimit);
      return true;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
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
          .get()
          .timeout(_timeLimit);
      List<Activity> activities = [];
      for (var element in querySnapshot.docs) {
        activities
            .add(Activity.fromMap(element.data() as Map<String, dynamic>));
      }
      return activities;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
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
          .get()
          .timeout(_timeLimit);

      // check if the time of the activity is before the current time
      for (var element in querySnapshot.docs) {
        Activity activity =
            Activity.fromMap(element.data() as Map<String, dynamic>);
        if (activity.time.isBefore(DateTime.now())) {
          await _fireStore
              .doc(element.id)
              .update({'status': Status.missed.index}).timeout(_timeLimit);
        }
      }
      return true;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
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
          .get()
          .timeout(_timeLimit);
      List<Activity> activities = [];
      for (var element in querySnapshot.docs) {
        activities
            .add(Activity.fromMap(element.data() as Map<String, dynamic>));
      }
      return activities;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
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
          .get()
          .timeout(_timeLimit);
      List<Activity> activities = [];
      for (var element in querySnapshot.docs) {
        activities
            .add(Activity.fromMap(element.data() as Map<String, dynamic>));
      }
      return activities;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
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
          .get()
          .timeout(_timeLimit);
      List<Activity> activities = [];
      for (var element in querySnapshot.docs) {
        activities
            .add(Activity.fromMap(element.data() as Map<String, dynamic>));
      }
      return activities;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }
}
