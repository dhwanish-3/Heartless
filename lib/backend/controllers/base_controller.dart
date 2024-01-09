import 'package:heartless/services/exceptions/app_exceptions.dart';
import 'package:heartless/services/utils/toast_message.dart';

mixin BaseController {
  ToastMessage toastMessage = ToastMessage();
  Future<bool> handleError(error) {
    if (error is BadRequestException) {
      toastMessage.showError(error.message ?? "Bad Request");
    } else if (error is FetchDataException) {
      toastMessage.showError(error.message ?? "Error During Communication");
    } else if (error is ApiNotRespondingException) {
      toastMessage.showError(error.message ?? "Api Not Responding");
    } else if (error is UnAutherizedException) {
      toastMessage.showError(error.message ?? "UnAutherized");
    } else {
      toastMessage.showError(error.message ?? "Something Went Wrong");
    }
    return Future.value(false);
  }
}
