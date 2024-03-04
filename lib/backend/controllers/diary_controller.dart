import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heartless/backend/controllers/base_controller.dart';
import 'package:heartless/backend/services/activity/diary_services.dart';
import 'package:heartless/shared/models/diary.dart';

class DiaryController with BaseController {
  // add a new reading
  Future<void> addDiary(Diary reading) async {
    DiaryService.addDiary(reading)
        .then((value) => handleSuccess(true, "Diary added"))
        .catchError(handleError);
  }

  // edit a reading
  Future<void> editDiary(Diary reading) async {
    DiaryService.editDiary(reading)
        .then((value) => handleSuccess(true, "Diary updated"))
        .catchError(handleError);
  }

  // delete a reading
  Future<void> deleteDiary(Diary reading) async {
    DiaryService.deleteDiary(reading)
        .then((value) => handleSuccess(true, "Diary deleted"))
        .catchError(handleError);
  }

  // get all readings of the date
  static Stream<QuerySnapshot> getAllDiarysOfTheDate(
      DateTime date, String patientId) {
    return DiaryService.getAllDiariesOfTheDate(date, patientId);
  }
}
