import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heartless/backend/controllers/base_controller.dart';
import 'package:heartless/backend/services/activity/activity_service.dart';
import 'package:heartless/shared/models/activity.dart';

class ActivityController with BaseController {
  final ActivityService _activityService = ActivityService();

  Future<bool> markAsCompleted(String activityId, String patientId) async {
    if (await _activityService
        .markAsCompleted(activityId, patientId)
        .then((value) => handleSuccess(value, "Activity marked as completed"))
        .catchError(handleError)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addActivity(Activity activity) async {
    if (await _activityService
        .addActivity(activity)
        .then((value) => handleSuccess(value, "Activity added"))
        .catchError(handleError)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteActivity(Activity activity) async {
    if (await _activityService
        .deleteActivity(activity)
        .then((value) => handleSuccess(value, "Activity deleted"))
        .catchError(handleError)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> editActivity(Activity activity) async {
    if (await _activityService
        .editActivity(activity)
        .then((value) => handleSuccess(value, "Activity updated"))
        .catchError(handleError)) {
      return true;
    } else {
      return false;
    }
  }

  static Stream<QuerySnapshot> getAllActivitiesOfTheDate(
      DateTime date, String patientId) {
    // Update activity status
    ActivityService.updateActivityStatus(patientId);
    return ActivityService.getAllActivitiesOfTheDate(date, patientId);
  }

  Stream<QuerySnapshot> getUpcomingActivitiesOftheDay(
      DateTime date, String patientId) {
    // Update activity status
    ActivityService.updateActivityStatus(patientId);
    return ActivityService.getUpcomingActivitiesOftheDay(date, patientId);
  }

  static Stream<QuerySnapshot> getCompletedActivitiesOftheDay(
      DateTime date, String patientId) {
    return ActivityService.getCompletedActivitiesOftheDay(date, patientId);
  }

  static Stream<QuerySnapshot> getMissedActivitiesOftheDay(
      DateTime date, String patientId) {
    return ActivityService.getMissedActivitiesOftheDay(date, patientId);
  }
}
