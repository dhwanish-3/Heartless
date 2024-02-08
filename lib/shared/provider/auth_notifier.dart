import 'package:flutter/foundation.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/models/doctor.dart';
import 'package:heartless/shared/models/nurse.dart';
import 'package:heartless/shared/models/patient.dart';

class AuthNotifier with ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  UserType _userType = UserType.patient;
  UserType get userType => _userType;
  void setUserType(UserType value) {
    _userType = value;
    notifyListeners();
  }

  // app user
  AppUser? _appUser;
  AppUser? get appUser => _appUser;

  void setAppUser(AppUser user) {
    _appUser = user;
    notifyListeners();
  }

  // if user is patient
  Patient? _patient;
  Patient? get patient => _patient;

  void setPatient(Patient user) {
    _patient = user;
    notifyListeners();
  }

  // if user is nurse
  Nurse? _nurse;
  Nurse? get nurse => _nurse;

  void setNurse(Nurse user) {
    _nurse = user;
    notifyListeners();
  }

  // if user is doctor
  Doctor? _doctor;
  Doctor? get doctor => _doctor;

  void setDoctor(Doctor user) {
    _doctor = user;
    notifyListeners();
  }
}
