import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heartless/services/date/date_service.dart';
import 'package:heartless/services/exceptions/app_exceptions.dart';
import 'package:heartless/shared/models/diary.dart';

class DiaryService {
  static Future<void> addDiary(Diary diary) async {
    try {
      DateTime startOfWeek = DateService.getStartOfWeek(diary.time);
      // getting the id of the new document
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('Patients')
          .doc(diary.patientId)
          .collection("WeeklyData")
          .doc(startOfWeek.toString())
          .collection("Diaries")
          .doc();
      diary.id = docRef.id;
      // adding the diary to the database
      await docRef.set(diary.toMap()).timeout(DateService.timeLimit);
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // edit a diary
  static Future<void> editDiary(Diary diary) async {
    try {
      if (diary.id.isEmpty) {
        return;
      }
      DateTime startOfWeek = DateService.getStartOfWeek(diary.time);

      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(diary.patientId)
          .collection("WeeklyData")
          .doc(startOfWeek.toString())
          .collection("Diaries")
          .doc(diary.id)
          .update(diary.toMap())
          .timeout(DateService.timeLimit);
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // delete a diary
  static Future<void> deleteDiary(Diary diary) async {
    try {
      if (diary.id.isEmpty) {
        return;
      }
      DateTime startOfWeek = DateService.getStartOfWeek(diary.time);

      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(diary.patientId)
          .collection("WeeklyData")
          .doc(startOfWeek.toString())
          .collection("Diaries")
          .doc(diary.id)
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

  // get all diarys of a day
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllDiariesOfTheDate(
      DateTime date, String patientId) {
    DateTime startOfWeek = DateService.getStartOfWeek(date);
    DateTime startOfDay = DateService.getStartOfDay(date);
    DateTime endOfDay = startOfDay.add(const Duration(days: 1));
    return FirebaseFirestore.instance
        .collection('Patients')
        .doc(patientId)
        .collection('WeeklyData')
        .doc(startOfWeek.toString())
        .collection('Diaries')
        .where('time', isGreaterThanOrEqualTo: startOfDay)
        .where('time', isLessThan: endOfDay)
        .snapshots();
  }
}
