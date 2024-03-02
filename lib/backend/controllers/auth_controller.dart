import 'package:heartless/backend/services/auth/auth.dart';
import 'package:heartless/backend/controllers/base_controller.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';

class AuthController with BaseController {
  final AuthService _authService = AuthService();
  Future<bool> login(AuthNotifier authNotifier) async {
    if (await _authService
        .login(authNotifier)
        .then((value) => handleSuccess(value, "Logged in"))
        .catchError(handleError)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> signUp(AuthNotifier authNotifier) async {
    if (await _authService
        .signUp(authNotifier)
        .then((value) => handleSuccess(value, "Signed up"))
        .catchError(handleError)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> googleSignIn(AuthNotifier authNotifier) async {
    if (await _authService
        .googleSignIn(authNotifier)
        .then((value) => handleSuccess(value, "Signed in with Google"))
        .catchError(handleError)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> logout(AuthNotifier authNotifier) async {
    if (await _authService
        .logout(authNotifier)
        .then((value) => handleSuccess(value, "Logged out"))
        .catchError(handleError)) {
      return true;
    } else {
      return false;
    }
  }

  // Forgot password Feature
  Future<bool> sendResetEmail(AuthNotifier authNotifier) async {
    if (await _authService
        .sendPasswordResetEmail(authNotifier)
        .then((value) => handleSuccess(value, "sent reset email"))
        .catchError(handleError)) {
      return true;
    } else {
      return false;
    }
  }
}
