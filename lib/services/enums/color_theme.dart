import 'package:flutter/material.dart';

enum ColorTheme {
  Default,
  Yellow,
  Orange,
  Green,
  Purple,
}

enum customBrightness { light, dark }

extension customBrightnessExtension on customBrightness {}

extension ColorThemeExtension on ColorTheme {
  Color get primaryColor {
    switch (this) {
      case ColorTheme.Default:
        return Color.fromARGB(255, 52, 190, 171);
      case ColorTheme.Yellow:
        return Colors.yellow;
      case ColorTheme.Orange:
        return Colors.orange;
      case ColorTheme.Green:
        return Colors.green;
      case ColorTheme.Purple:
        return Colors.purple;
      default:
        return Color.fromARGB(255, 52, 190, 171);
    }
  }

  Color get lightPrimaryColor {
    switch (this) {
      case ColorTheme.Default:
        return Color.fromARGB(255, 202, 230, 226);
      case ColorTheme.Yellow:
        return Color.fromARGB(255, 233, 221, 119);
      case ColorTheme.Orange:
        return Color.fromARGB(255, 239, 185, 104);
      case ColorTheme.Green:
        return Color.fromARGB(255, 117, 232, 120);
      case ColorTheme.Purple:
        return Color.fromARGB(255, 230, 132, 248);

      default:
        return Color.fromARGB(255, 202, 230, 226);
    }
  }
}
