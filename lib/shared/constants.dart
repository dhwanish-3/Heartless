import 'package:flutter/material.dart';

class Constants {
  static const primaryColor = Color.fromARGB(255, 55, 244, 218);
  static const darkPrimaryColor = Color.fromARGB(255, 212, 64, 64);
  static const customGray = Color.fromARGB(255, 160, 168, 176);

  TextTheme textThemeLight = const TextTheme(
    displayLarge: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      color: primaryColor,
    ),
    bodyLarge: TextStyle(
      color: customGray,
      fontWeight: FontWeight.w600,
      fontSize: 13,
    ),
    bodyMedium: TextStyle(
      color: primaryColor,
      fontWeight: FontWeight.w600,
      fontSize: 14,
    ),
  );
}
