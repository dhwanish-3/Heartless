import 'package:flutter/material.dart';
import 'package:heartless/services/enums/color_theme.dart';
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
    primaryColorLight: Constants.lightPrimaryColor,
    textTheme: Constants().textThemeLight,
    canvasColor: Colors.white,
    shadowColor: Colors.black,
    highlightColor: Colors.grey, //color used for boxshadow
    secondaryHeaderColor: Constants.cardColor, //widget background color
  );
//* for widgets that have to alternate between white and black colors give them canvasColor and shadowColor fot the converse

  ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Constants.primaryColor,
    primaryColorLight: Constants.lightPrimaryColor,
    textTheme: Constants().textThemeDark,
    canvasColor: Colors.black,
    shadowColor: Colors.white,
    highlightColor: Colors.black,
    secondaryHeaderColor: Constants.darkCardColor,
  );

  ColorTheme _colorTheme = ColorTheme.Default;

  ColorTheme get colorTheme => _colorTheme;

  void setColorTheme(ColorTheme colorTheme) {
    _colorTheme = colorTheme;

    lightTheme = lightTheme.copyWith(
      primaryColor: colorTheme.primaryColor,
      primaryColorLight: colorTheme.lightPrimaryColor,
    );

    darkTheme = darkTheme.copyWith(
      primaryColor: colorTheme.primaryColor,
      primaryColorLight: colorTheme.lightPrimaryColor,
    );
    notifyListeners();
  }
}
