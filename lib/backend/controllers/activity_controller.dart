import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heartless/backend/controllers/base_controller.dart';
import 'package:heartless/backend/services/activity/activity_service.dart';
import 'package:heartless/backend/services/notifications/notification_services.dart';
import 'package:heartless/services/enums/activity_status.dart';
import 'package:heartless/shared/models/activity.dart';

class ActivityController with BaseController {
  final ActivityService _activityService = ActivityService();

  Future<bool> markAsCompleted(Activity activity, String patientId) async {
    if (activity.status == ActivityStatus.completed) {
      return true;
    }
    // activity can be marked as completed only before 30 minutes of its time
    if (activity.time.isAfter(DateTime.now().add(Duration(minutes: 30)))) {
      handleError("Activity can't be marked as completed now");
      return false;
    }
    // activity can not be marked as completed after half an hour of its time
    if (activity.time
        .isBefore(DateTime.now().subtract(Duration(minutes: 30)))) {
      handleError("Activity can't be marked as completed now");
      return false;
    }
    if (await _activityService
        .markAsCompleted(activity.id, patientId)
        .then((value) => handleSuccess(value, "Activity marked as completed"))
        .catchError(handleError)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addActivity(Activity activity) async {
    if (await _activityService.addActivity(activity).then((value) async {
      await NotificationService.scheduleNotification(
        title: activity.name,
        body: activity.description,
        payload: "Go to schedule page",
        scheduledTime: activity.time,
      );
      // await NotificationService.showSimpleNotification(
      //   title: activity.name,
      //   body: activity.description,
      //   payload: "Go to schedule page",
      // );
      return handleSuccess(value, "Activity added");
    }).catchError(handleError)) {
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
    ActivityService.updateActivityStatus(date, patientId);
    return ActivityService.getAllActivitiesOfTheDate(date, patientId);
  }

  static Stream<QuerySnapshot> getAllActivitiesForAWeek(
      DateTime date, String patientId) {
    // Update activity status
    return ActivityService.getAllActivitiesForAWeek(date, patientId);
  }

  static Stream<QuerySnapshot> getUpcomingActivitiesOftheDay(
      DateTime date, String patientId) {
    // Update activity status
    ActivityService.updateActivityStatus(date, patientId);
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
