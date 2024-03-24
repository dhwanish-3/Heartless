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
    textTheme: Constants().textThemeLight,
    canvasColor: Colors.white,
    shadowColor: Colors.black,
    highlightColor: Colors.grey, //color used for boxshadow
  );
//* for widgets that have to alternate between white and black colors give them canvasColor and shadowColor fot the converse

  ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Constants.primaryColor,
    textTheme: Constants().textThemeDark,
    canvasColor: Colors.black,
    shadowColor: Colors.white,
    highlightColor: Colors.black,
  );
}
