import 'package:flutter/foundation.dart';
import 'package:heartless/shared/Models/patient.dart';

class AuthNotifier with ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  String _userType = 'patient';
  String get userType => _userType;
  void setUserType(String value) {
    _userType = value;
    notifyListeners();
  }

  Patient _patient = Patient();
  Patient get patient => _patient;

  void setPatient(Patient user) {
    _patient = user;
    notifyListeners();
  }
}
