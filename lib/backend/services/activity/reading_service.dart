import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heartless/services/date/date_service.dart';
import 'package:heartless/services/exceptions/app_exceptions.dart';
import 'package:heartless/shared/models/reading.dart';

class ReadingService {
  // add a new reading
  static Future<void> addReading(Reading reading) async {
    try {
      DateTime startOfWeek = DateService.getStartOfWeek(reading.time);
      // getting the id of the new document
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(reading.patientId)
          .collection("WeeklyData")
          .doc(startOfWeek.toString())
          .collection("Readings")
          .doc();
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
      DateTime startOfWeek = DateService.getStartOfWeek(reading.time);

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(reading.patientId)
          .collection("WeeklyData")
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
      DateTime startOfWeek = DateService.getStartOfWeek(reading.time);

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(reading.patientId)
          .collection("WeeklyData")
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
    DateTime startOfWeek = DateService.getStartOfWeek(date);
    DateTime startOfDay = DateService.getStartOfDay(date);
    DateTime endOfDay = startOfDay.add(const Duration(days: 1));
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(patientId)
        .collection('WeeklyData')
        .doc(startOfWeek.toString())
        .collection('Readings')
        .where('time', isGreaterThanOrEqualTo: startOfDay)
        .where('time', isLessThan: endOfDay)
        .snapshots();
  }

  // get all the readings for a given week
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllReadingsOfTheWeek(
    DateTime date,
    String patientId,
  ) {
    DateTime startOfWeek = DateService.getStartOfWeek(date);
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(patientId)
        .collection('WeeklyData')
        .doc(startOfWeek.toString())
        .collection('Readings')
        .snapshots();
  }

  static Future<List<Reading>> getAllReadingsOfTheWeekasList(
      DateTime date, String patientId,
      {int? limit}) async {
    DateTime startOfWeek = DateService.getStartOfWeek(date);
    List<Reading> readings = [];
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(patientId)
        .collection('WeeklyData')
        .doc(startOfWeek.toString())
        .collection('Readings')
        .orderBy('time', descending: true)
        .limit(limit ?? 30)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        readings.add(Reading.fromMap(element.data()));
      });
    });
    return readings;
  }
}
