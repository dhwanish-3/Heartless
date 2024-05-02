import 'dart:developer';

import 'package:heartless/services/exceptions/app_exceptions.dart';
import 'package:heartless/services/utils/toast_message.dart';

mixin BaseController {
  ToastMessage toastMessage = ToastMessage();
  // Show error message
  Future<bool> handleError(error) {
    log(error.toString());
    if (error is BadRequestException) {
      toastMessage.showError(error.toString());
    } else if (error is FetchDataException) {
      toastMessage.showError(error.toString());
    } else if (error is ApiNotRespondingException) {
      toastMessage.showError(error.toString());
    } else if (error is UnAutherizedException) {
      toastMessage.showError(error.toString());
    } else {
      toastMessage.showError(error.toString());
    }
    return Future.value(false);
  }

  // Show success message
  Future<bool> handleSuccess(success, String message) async {
    if (success == null) return Future.value(false);
    if (success == true) {
      toastMessage.showSuccess("Successfully $message");
    }
    return Future.value(true);
  }
}
