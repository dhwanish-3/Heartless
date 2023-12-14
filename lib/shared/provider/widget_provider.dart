import 'package:flutter/material.dart';

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

  //for swtiching the toggle button
  bool _emailPhoneToggle = true;
  bool get emailPhoneToggle => _emailPhoneToggle;
  void toggleEmailPhone() {
    _emailPhoneToggle = !_emailPhoneToggle;
    notifyListeners();
  }
}
