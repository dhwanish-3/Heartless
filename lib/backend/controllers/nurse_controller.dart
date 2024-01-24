import 'package:heartless/backend/services/auth/nurse_auth.dart';
import 'package:heartless/backend/controllers/base_controller.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';

class NurseController with BaseController {
  final NurseAuth _nurseAuth = NurseAuth();

  // Login and Sign up Feature
  Future<bool> login(AuthNotifier authNotifier) async {
    if (await _nurseAuth
        .loginNurse(authNotifier)
        .then((value) => handleSuccess(value, "Logged in"))
        .catchError(handleError)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> signUp(AuthNotifier authNotifier) async {
    if (await _nurseAuth
        .signUpNurse(authNotifier)
        .then((value) => handleSuccess(value, "Signed up"))
        .catchError(handleError)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> googleSignIn(AuthNotifier authNotifier) async {
    if (await _nurseAuth
        .googleSignIn(authNotifier)
        .then((value) => handleSuccess(value, "Signed in with Google"))
        .catchError(handleError)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> logout(AuthNotifier authNotifier) async {
    if (await _nurseAuth
        .logoutNurse(authNotifier)
        .then((value) => handleSuccess(value, "Logged out"))
        .catchError(handleError)) {
      return true;
    } else {
      return false;
    }
  }

  // Forgot password Feature
  Future<bool> sendResetEmail(AuthNotifier authNotifier) async {
    if (await _nurseAuth
        .sendPasswordResetEmail(authNotifier)
        .then((value) => handleSuccess(value, "sent reset email"))
        .catchError(handleError)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> verifyOTP(AuthNotifier authNotifier, String code) async {
    if (await _nurseAuth
        .verifyOTP(authNotifier, code)
        .then((value) => handleSuccess(value, "Verified OTP"))
        .catchError(handleError)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> setNewPassword(
      AuthNotifier authNotifier, String password) async {
    if (await _nurseAuth
        .setNewPassword(authNotifier, password)
        .then((value) => handleSuccess(
            value, "set new password. Please login with new password"))
        .catchError(handleError)) {
      return true;
    } else {
      return false;
    }
  }
}
