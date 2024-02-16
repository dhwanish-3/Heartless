import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heartless/backend/services/activity/date_service.dart';
import 'package:heartless/services/exceptions/app_exceptions.dart';
import 'package:heartless/shared/models/reading.dart';

class ReadingService {
  static final _dataRef = FirebaseFirestore.instance
      .collection('Patients')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("WeeklyData");

  // add a new reading
  static Future<void> addReading(Reading reading) async {
    try {
      DateTime startOfWeek = DateService.getStartOfWeekOfDate(reading.time);
      // getting the id of the new document
      DocumentReference docRef =
          _dataRef.doc(startOfWeek.toString()).collection("Readings").doc();
      reading.id = docRef.id;
      // adding the reading to the database
      await docRef.set(reading.toMap()).timeout(DateService.timeLimit);
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // edit a reading
  static Future<void> editReading(Reading reading) async {
    try {
      if (reading.id.isEmpty) {
        return;
      }
      DateTime startOfWeek = DateService.getStartOfWeekOfDate(reading.time);

      await _dataRef
          .doc(startOfWeek.toString())
          .collection("Readings")
          .doc(reading.id)
          .update(reading.toMap())
          .timeout(DateService.timeLimit);
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // delete a reading
  static Future<void> deleteReading(Reading reading) async {
    try {
      if (reading.id.isEmpty) {
        return;
      }
      DateTime startOfWeek = DateService.getStartOfWeekOfDate(reading.time);

      await _dataRef
          .doc(startOfWeek.toString())
          .collection("Readings")
          .doc(reading.id)
          .delete()
          .timeout(DateService.timeLimit);
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // get all readings of a day
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllReadingsOfTheDate(
      DateTime date, String patientId) {
    DateTime startOfDay = DateService.getStartOfDay(date);
    DateTime endOfDay = startOfDay.add(const Duration(days: 1));
    return FirebaseFirestore.instance
        .collection('Patients')
        .doc(patientId)
        .collection('WeeklyData')
        .doc(startOfDay.toString())
        .collection('Readings')
        .where('time', isGreaterThanOrEqualTo: startOfDay)
        .where('time', isLessThan: endOfDay)
        .snapshots();
  }

  // get all the readings for a given week
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllReadingsOfTheWeek(
      DateTime date, String patientId) {
    DateTime startOfWeek = DateService.getStartOfWeekOfDate(date);
    return FirebaseFirestore.instance
        .collection('Patients')
        .doc(patientId)
        .collection('WeeklyData')
        .doc(startOfWeek.toString())
        .collection('Readings')
        .snapshots();
  }
}
