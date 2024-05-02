import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:heartless/services/enums/schedule_toggle_type.dart';

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

  // for bottom navigation bar
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  void setSelectedIndex(int index) {
    _selectedIndex = index;
    log("Selected Index: $_selectedIndex");
    notifyListeners();
  }

  // for swtiching the toggle button
  bool _emailPhoneToggle = true;
  bool get emailPhoneToggle => _emailPhoneToggle;
  void toggleEmailPhone() {
    _emailPhoneToggle = !_emailPhoneToggle;
    notifyListeners();
  }

  // login or signup toggle
  bool _showLogin = true;
  bool get showLogin => _showLogin;
  void toggleLoginSignup() {
    _showLogin = !_showLogin;
    notifyListeners();
  }

  // toggle for the schedule page
  ScheduleToggleType _scheduleToggleType = ScheduleToggleType.all;
  ScheduleToggleType get scheduleToggleType => _scheduleToggleType;
  void changeToggleSelection(ScheduleToggleType scheduleToggleType) {
    _scheduleToggleType = scheduleToggleType;
    notifyListeners();
  }

  // date selected in the schedule page
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  // set the date to today without notifying the listeners
  void setSelectedDateWithoutNotifying(DateTime date) {
    _selectedDate = date;
  }

  // list of dates selected in the create schedule page
  List<DateTime> _chosenDates = [];
  List<DateTime> get chosenDates => _chosenDates;
  void addChosenDate(DateTime date) {
    _chosenDates.add(date);
    notifyListeners();
  }

  void removeChosenDate(DateTime date) {
    _chosenDates.remove(date);
    notifyListeners();
  }

  bool _isGraphEmpty = true;
  bool get isGraphEmpty => _isGraphEmpty;
  void setIsGraphEmpty(bool value) {
    _isGraphEmpty = value;
    notifyListeners();
  }

  void setIsGraphEmptyWithoutNotifying(bool value) {
    _isGraphEmpty = value;
  }
}
