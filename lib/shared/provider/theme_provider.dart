import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';

class ThemeNotifier extends ChangeNotifier {
  static ThemeMode _themeMode = ThemeMode.system;

  static ThemeMode get themeMode => _themeMode;

  void toggleThemeMode() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: Constants.primaryColor,
      textTheme: Constants().textThemeLight);

  ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Constants.darkPrimaryColor,
  );
}
