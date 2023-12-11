class AppException implements Exception {
  String? message = 'Something went wrong...';
  String? prefix = 'Exception';

  AppException([this.message, this.prefix]);

  @override
  String toString() {
    return message ?? 'Something went wrong...';
  }
}

class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message, 'Bad Request');
}

class FetchDataException extends AppException {
  FetchDataException([String? message]) : super(message, 'Unable to process');
}

class ApiNotRespondingException extends AppException {
  ApiNotRespondingException([String? message])
      : super(message, 'API did not respond in time');
}

class UnAutherizedException extends AppException {
  UnAutherizedException([String? message])
      : super(message, 'Unautherized Request');
}
