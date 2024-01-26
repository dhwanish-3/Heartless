import 'package:flutter/material.dart';
import 'package:heartless/shared/models/app_user.dart';

class WidgetNotifier with ChangeNotifier {
  // for circular progress indicator
  bool _loading = false;
  bool get loading => _loading;
  void setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  // for hiding/showing password
  bool _passwordShown = true;
  bool get passwordShown => _passwordShown;
  void setPasswordShown(bool passwordShown) {
    _passwordShown = passwordShown;
    notifyListeners();
  }

  // for swtiching the toggle button
  bool _emailPhoneToggle = true;
  bool get emailPhoneToggle => _emailPhoneToggle;
  void toggleEmailPhone() {
    _emailPhoneToggle = !_emailPhoneToggle;
    notifyListeners();
  }

  // choose user type in choose user type page
  UserType _userType = UserType.patient;
  UserType get userType => _userType;
  void setUserType(UserType userType) {
    _userType = userType;
    notifyListeners();
  }

  // login or signup toggle
  bool _showLogin = true;
  bool get showLogin => _showLogin;
  void toggleLoginSignup() {
    _showLogin = !_showLogin;
    notifyListeners();
  }
}
