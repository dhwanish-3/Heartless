import 'package:flutter/foundation.dart';
import 'package:heartless/shared/models/app_user.dart';

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
}
