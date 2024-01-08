import 'package:heartless/backend/auth/patient_auth.dart';
import 'package:heartless/backend/controllers/base_controller.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';

class PatientController with BaseController {
  final PatientAuth _patientAuth = PatientAuth();
  Future<void> login(AuthNotifier authNotifier) async {
    await _patientAuth.loginPatient(authNotifier).catchError(handleError);
  }

  Future<void> signUp(AuthNotifier authNotifier) async {
    await _patientAuth.signUpPatient(authNotifier).catchError(handleError);
  }

  Future<void> logout(AuthNotifier authNotifier) async {
    await _patientAuth.logoutPatient(authNotifier).catchError(handleError);
  }

  Future<void> googleSignIn(AuthNotifier authNotifier) async {
    await _patientAuth.googleSignIn(authNotifier).catchError(handleError);
  }
}
