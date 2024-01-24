import 'package:heartless/backend/controllers/base_controller.dart';
import 'package:heartless/backend/services/activity/activity_service.dart';
import 'package:heartless/shared/models/activity.dart';

class ActivityController with BaseController {
  final ActivityService _activityService = ActivityService();

  Future<bool> markAsCompleted(String activityId) async {
    if (await _activityService
        .markAsCompleted(activityId)
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

  Future<List<Activity>> getAllActivitiesOfTheDate(DateTime date) async {
    // Update activity status
    if (!await _activityService.updateActivityStatus().then((value) {
      handleSuccess(value, "Activity status updated");
      return true;
    }).catchError(handleError)) {
      return [];
    }
    List<Activity> result = [];
    if (await _activityService.getAllActivitiesOfTheDate(date).then((value) {
      handleSuccess(value, "Activities fetched");
      if (value == []) {
        return false;
      } else {
        result = value;
        return true;
      }
    }).catchError(handleError)) {}
    return result;
  }

  Future<List<Activity>> getUpcomingActivitiesOftheDay(DateTime date) async {
    // Update activity status
    if (!await _activityService.updateActivityStatus().then((value) {
      handleSuccess(value, "Activity status updated");
      return true;
    }).catchError(handleError)) {
      return [];
    }
    List<Activity> result = [];
    if (await _activityService
        .getUpcomingActivitiesOftheDay(date)
        .then((value) {
      handleSuccess(value, "Activities fetched");
      if (value == []) {
        return false;
      } else {
        result = value;
        return true;
      }
    }).catchError(handleError)) {}
    return result;
  }

  Future<List<Activity>> getCompletedActivitiesOftheDay(DateTime date) async {
    List<Activity> result = [];
    if (await _activityService
        .getCompletedActivitiesOftheDay(date)
        .then((value) {
      handleSuccess(value, "Activities fetched");
      if (value == []) {
        return false;
      } else {
        result = value;
        return true;
      }
    }).catchError(handleError)) {}
    return result;
  }

  Future<List<Activity>> getMissedActivitiesOftheDay(DateTime date) async {
    List<Activity> result = [];
    if (await _activityService.getMissedActivitiesOftheDay(date).then((value) {
      handleSuccess(value, "Activities fetched");
      if (value == []) {
        return false;
      } else {
        result = value;
        return true;
      }
    }).catchError(handleError)) {}
    return result;
  }
}
