import 'package:flutter/material.dart';

enum ColorTheme {
  Default,
  Yellow,
  Orange,
  Green,
  Purple,
}

extension ColorThemeExtension on ColorTheme {
  Color get primaryColor {
    switch (this) {
      case ColorTheme.Default:
        return Color.fromARGB(255, 52, 190, 171);
      case ColorTheme.Yellow:
        return Color.fromARGB(255, 255, 230, 0);
      case ColorTheme.Orange:
        return const Color.fromARGB(255, 255, 158, 14);
      case ColorTheme.Green:
        return const Color.fromARGB(255, 99, 223, 103);
      case ColorTheme.Purple:
        return Color.fromARGB(255, 203, 93, 223);
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
        return Color.fromARGB(255, 239, 148, 255);

      default:
        return Color.fromARGB(255, 202, 230, 226);
    }
  }
}
