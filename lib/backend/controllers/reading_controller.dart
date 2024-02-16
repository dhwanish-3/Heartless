import 'package:heartless/backend/controllers/base_controller.dart';
import 'package:heartless/backend/services/activity/reading_service.dart';
import 'package:heartless/shared/models/reading.dart';

class ReadingController with BaseController {
  // add a new reading
  Future<void> addReading(Reading reading) async {
    ReadingService.addReading(reading)
        .then((value) => handleSuccess(true, "Reading added"))
        .catchError(handleError);
  }

  // edit a reading
  Future<void> editReading(Reading reading) async {
    ReadingService.editReading(reading)
        .then((value) => handleSuccess(true, "Reading updated"))
        .catchError(handleError);
  }

  // delete a reading
  Future<void> deleteReading(Reading reading) async {
    ReadingService.deleteReading(reading)
        .then((value) => handleSuccess(true, "Reading deleted"))
        .catchError(handleError);
  }
}
