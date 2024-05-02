import 'package:flutter/material.dart';

class AnalyticsNotifier with ChangeNotifier {
  // for swtiching the toggle button
  bool _activityReadingToggle = true;
  bool get emailPhoneToggle => _activityReadingToggle;
  void toggleActivityReading() {
    _activityReadingToggle = !_activityReadingToggle;
    notifyListeners();
  }

  DateTime _chosenDate = DateTime.now();
  void setDate(DateTime date) {
    _chosenDate = date;
    notifyListeners();
  }

  void setSelectedDateWithoutNotifying(date) {
    _chosenDate = date;
  }

  DateTime get chosenDate => _chosenDate;

  int _selectedMonth = DateTime.now().month;
  void setMonth(int month) {
    _selectedMonth = month;
    notifyListeners();
  }

  void setSelectedMonthWithoutNotifying(month) {
    _selectedMonth = month;
  }

  int get selectedMonth => _selectedMonth;

  int _selectedYear = DateTime.now().year;
  void setYear(int year) {
    _selectedYear = year;
    notifyListeners();
  }

  void setSelectedYearWithoutNotifying(year) {
    _selectedYear = year;
  }

  int get selectedYear => _selectedYear;
}
