import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heartless/backend/controllers/base_controller.dart';
import 'package:heartless/backend/services/demonstration/demonstration_service.dart';
import 'package:heartless/shared/models/demonstration.dart';

class DemonstrationController with BaseController {
  final DemonstrationService _demonstrationService = DemonstrationService();

  Future<bool> addDemo(Demonstration demo) async {
    if (await _demonstrationService
        .addDemo(demo)
        .then((value) => handleSuccess(value, "Demo added"))
        .catchError(handleError)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateDemo(Demonstration demo) async {
    if (await _demonstrationService
        .updateDemo(demo)
        .then((value) => handleSuccess(value, "Demo updated"))
        .catchError(handleError)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteDemo(String id) async {
    if (await _demonstrationService
        .deleteDemo(id)
        .then((value) => handleSuccess(value, "Demo deleted"))
        .catchError(handleError)) {
      return true;
    } else {
      return false;
    }
  }

  Stream<QuerySnapshot> getDemos() {
    return _demonstrationService.getDemos();
  }
}
