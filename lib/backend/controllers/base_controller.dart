import 'package:heartless/services/exceptions/app_exceptions.dart';

mixin BaseController {
  Future<bool> handleError(error) {
    if (error is BadRequestException) {
      print(error.message);
    } else if (error is FetchDataException) {
      print(error.message);
    } else if (error is ApiNotRespondingException) {
      print(error.message);
    } else if (error is UnAutherizedException) {
      print(error.message);
    }
    return Future.value(false);
  }
}
