import 'package:heartless/services/exceptions/app_exceptions.dart';
import 'package:heartless/services/utils/toast_message.dart';

mixin BaseController {
  ToastMessage toastMessage = ToastMessage();
  Future<bool> handleError(error) {
    if (error is BadRequestException) {
      toastMessage.showError(error.toString() ?? "Bad Request");
    } else if (error is FetchDataException) {
      toastMessage.showError(error.toString() ?? "Error During Communication");
    } else if (error is ApiNotRespondingException) {
      toastMessage.showError(error.toString() ?? "Api Not Responding");
    } else if (error is UnAutherizedException) {
      toastMessage.showError(error.toString() ?? "UnAutherized");
    } else {
      toastMessage.showError(error.toString() ?? "Something Went Wrong");
    }
    return Future.value(false);
  }
}
