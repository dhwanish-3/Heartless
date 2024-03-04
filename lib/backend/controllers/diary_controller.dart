import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heartless/backend/controllers/base_controller.dart';
import 'package:heartless/backend/services/activity/diary_services.dart';
import 'package:heartless/shared/models/diary.dart';

class DiaryController with BaseController {
  // add a new diary
  Future<void> addDiary(Diary diary) async {
    DiaryService.addDiary(diary)
        .then((value) => handleSuccess(true, "Diary added"))
        .catchError(handleError);
  }

  // edit a diary
  Future<void> editDiary(Diary diary) async {
    DiaryService.editDiary(diary)
        .then((value) => handleSuccess(true, "Diary updated"))
        .catchError(handleError);
  }

  // delete a diary
  Future<void> deleteDiary(Diary diary) async {
    DiaryService.deleteDiary(diary)
        .then((value) => handleSuccess(true, "Diary deleted"))
        .catchError(handleError);
  }

  // get all diarys of the date
  static Stream<QuerySnapshot> getAllDiarysOfTheDate(
      DateTime date, String patientId) {
    return DiaryService.getAllDiariesOfTheDate(date, patientId);
  }
}
