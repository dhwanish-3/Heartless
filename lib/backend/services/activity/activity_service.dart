import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heartless/services/date/date_service.dart';
import 'package:heartless/services/enums/activity_status.dart';
import 'package:heartless/services/exceptions/app_exceptions.dart';
import 'package:heartless/shared/models/activity.dart';

class ActivityService {
  // mark as completed
  Future<bool> markAsCompleted(String activityId, String patientId) async {
    // activity can be marked as completed only if it belongs to the current week
    DateTime startOfWeek = DateService.getStartOfWeek(DateTime.now());
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(patientId)
          .collection("WeeklyData")
          .doc(startOfWeek.toString())
          .collection('Activities')
          .doc(activityId)
          .update({'status': ActivityStatus.completed.index}).timeout(
              DateService.timeLimit);
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
      DateTime startOfWeek = DateService.getStartOfWeek(activity.time);
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('Users')
          .doc(activity.patientId)
          .collection("WeeklyData")
          .doc(startOfWeek.toString())
          .collection('Activities')
          .doc();
      // getting the id for the new activity from the reference
      activity.id = documentReference.id;
      await documentReference
          .set(activity.toMap())
          .timeout(DateService.timeLimit);
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
      DateTime startOfWeek = DateService.getStartOfWeek(activity.time);
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(activity.patientId)
          .collection("WeeklyData")
          .doc(startOfWeek.toString())
          .collection('Activities')
          .doc(activity.id)
          .update(activity.toMap())
          .timeout(DateService.timeLimit);
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
      DateTime startOfWeek = DateService.getStartOfWeek(activity.time);
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(activity.patientId)
          .collection("WeeklyData")
          .doc(startOfWeek.toString())
          .collection('Activities')
          .doc(activity.id)
          .delete()
          .timeout(DateService.timeLimit);
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
  static Stream<QuerySnapshot> getAllActivitiesOfTheDate(
      DateTime date, String patientId) {
    DateTime startOfWeek = DateService.getStartOfWeek(date);
    DateTime startOfDay = DateService.getStartOfDay(date);
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(patientId)
        .collection("WeeklyData")
        .doc(startOfWeek.toString())
        .collection('Activities')
        .where('time', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('time',
            isLessThan:
                Timestamp.fromDate(startOfDay.add(const Duration(days: 1))))
        .snapshots();
  }

  // to get update the activity status according to the time
  static Future<bool> updateActivityStatus(
      DateTime date, String patientId) async {
    // get the Datetime with for the start of the week
    DateTime startOfWeek = DateService.getStartOfWeek(date);
    try {
      // get all the activities with status upcoming
      QuerySnapshot upcomingActivities = await FirebaseFirestore.instance
          .collection('Users')
          .doc(patientId)
          .collection("WeeklyData")
          .doc(startOfWeek.toString())
          .collection('Activities')
          .where('status', isEqualTo: ActivityStatus.upcoming.index)
          .get()
          .timeout(DateService.timeLimit);

      // filter the activities with time before the current time and update the status to missed
      for (var element in upcomingActivities.docs) {
        Activity activity =
            Activity.fromMap(element.data() as Map<String, dynamic>);
        // if the time of the activity is before half an hour of the current time
        if (activity.time
            .isBefore(DateTime.now().subtract(Duration(minutes: 30)))) {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(patientId)
              .collection("WeeklyData")
              .doc(startOfWeek.toString())
              .collection('Activities')
              .doc(element.id)
              .update({'status': ActivityStatus.missed.index}).timeout(
                  DateService.timeLimit);
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
  static Stream<QuerySnapshot> getCompletedActivitiesOftheDay(
      DateTime dateTime, String patientId) {
    DateTime startOfWeek = DateService.getStartOfWeek(dateTime);
    DateTime startOfDay = DateService.getStartOfDay(dateTime);
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(patientId)
        .collection("WeeklyData")
        .doc(startOfWeek.toString())
        .collection('Activities')
        .where('time', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('time',
            isLessThan:
                Timestamp.fromDate(startOfDay.add(const Duration(days: 1))))
        .where('status', isEqualTo: ActivityStatus.completed.index)
        .snapshots();
  }

  // to get all upcoming activities of the day
  static Stream<QuerySnapshot> getUpcomingActivitiesOftheDay(
      DateTime dateTime, String patientId) {
    DateTime startOfWeek = DateService.getStartOfWeek(dateTime);
    DateTime startOfDay = DateService.getStartOfDay(dateTime);
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(patientId)
        .collection("WeeklyData")
        .doc(startOfWeek.toString())
        .collection('Activities')
        .where('time', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('time',
            isLessThan:
                Timestamp.fromDate(startOfDay.add(const Duration(days: 1))))
        .where('status', isEqualTo: ActivityStatus.upcoming.index)
        .snapshots();
  }

  // to get all missed activities of the day
  static Stream<QuerySnapshot> getMissedActivitiesOftheDay(
      DateTime dateTime, String patientId) {
    DateTime startOfWeek = DateService.getStartOfWeek(dateTime);
    DateTime startOfDay = DateService.getStartOfDay(dateTime);
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(patientId)
        .collection("WeeklyData")
        .doc(startOfWeek.toString())
        .collection('Activities')
        .where('time', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('time',
            isLessThan:
                Timestamp.fromDate(startOfDay.add(const Duration(days: 1))))
        .where('status', isEqualTo: ActivityStatus.missed.index)
        .snapshots();
  }

  // to get all the activities for a given period
  static Stream<QuerySnapshot> getAllActivitiesForAWeek(
      DateTime date, String patientId) {
    DateTime startOfWeek = DateService.getStartOfWeek(date);
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(patientId)
        .collection("WeeklyData")
        .doc(startOfWeek.toString())
        .collection('Activities')
        .snapshots();
  }

  static Future<List<Activity>> getAllActivitiesOfTheWeekasList(
      DateTime date, String patientId,
      {int? limit}) async {
    DateTime startOfWeek = DateService.getStartOfWeek(date);
    List<Activity> activities = [];
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(patientId)
        .collection('WeeklyData')
        .doc(startOfWeek.toString())
        .collection('Activities')
        .orderBy('time', descending: true)
        .limit(limit ?? 30)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        activities.add(Activity.fromMap(element.data()));
      });
    });
    return activities;
  }
}
