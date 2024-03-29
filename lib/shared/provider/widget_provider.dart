import 'package:flutter/material.dart';
import 'package:heartless/services/enums/schedule_toggle_type.dart';
import 'package:intl/intl.dart';

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

  //* for the analytics page
  //startDate
  DateTime _analyticsStartDate = DateTime.now();
  void setAnalyticsStartDate(DateTime date) {
    _analyticsStartDate = date;
    notifyListeners();
  }

  void setAnalyticsStartDateWithoutNotifying(DateTime date) {
    _analyticsStartDate = date;
  }

  DateTime get analyticsStartDate => _analyticsStartDate;

  //selected month
  String _analyticsSelectedMonth =
      DateFormat('MMM').format(DateTime.now()).toUpperCase();

  void setAnalyticsSelectedMonth(String month) {
    _analyticsSelectedMonth = month;
    notifyListeners();
  }

  void setAnalyticsSelectedMonthWithoutNotifying(String month) {
    _analyticsSelectedMonth = month;
  }

  String get analyticsSelectedMonth => _analyticsSelectedMonth;

//selected year
  int _analyticsSelectedYear = DateTime.now().year;
  void setAnalyticsSelectedYear(int year) {
    _analyticsSelectedYear = year;
    notifyListeners();
  }

  void setAnalyticsSelectedYearWithoutNotifying(int year) {
    _analyticsSelectedYear = year;
  }

  int get analyticsSelectedYear => _analyticsSelectedYear;

  bool _isGraphEmpty = false;
  bool get isGraphEmpty => _isGraphEmpty;
  void setGraphEmpty(bool isEmpty) {
    _isGraphEmpty = isEmpty;
    notifyListeners();
  }

  void setGraphEmptyWithoutNotifying(bool isEmpty) {
    _isGraphEmpty = isEmpty;
  }
}
