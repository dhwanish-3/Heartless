import 'package:flutter/material.dart';
import 'package:heartless/services/enums/color_theme.dart';
import 'package:heartless/shared/constants.dart';

class ThemeNotifier extends ChangeNotifier {
  static ThemeMode _themeMode = ThemeMode.light;

  static ThemeMode get themeMode => _themeMode;

  void toggleThemeMode() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setThemeMode(Brightness brightness) {
    _themeMode =
        brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Constants.primaryColor,
      secondary: Constants.primaryColor.withOpacity(0.5),
    ),
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
    colorScheme: ColorScheme.dark(
      primary: Constants.primaryColor,
      secondary: Constants.primaryColor.withOpacity(0.5),
    ),
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
      colorScheme: ColorScheme.light(
        primary: colorTheme.primaryColor,
      ),
      primaryColorLight: colorTheme.lightPrimaryColor,
    );

    darkTheme = darkTheme.copyWith(
      primaryColor: colorTheme.primaryColor,
      colorScheme: ColorScheme.dark(
        primary: colorTheme.primaryColor,
      ),
      primaryColorLight: colorTheme.lightPrimaryColor,
    );
    notifyListeners();
  }
}
