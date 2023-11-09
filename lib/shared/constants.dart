import 'package:flutter/material.dart';

class Constants {
  final primaryColor = const Color.fromARGB(255, 55, 244, 218);
  final darkPrimaryColor = const Color.fromARGB(255, 212, 64, 64);
  final customGray = const Color.fromARGB(255, 160, 168, 176);

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
      color: Color.fromARGB(255, 55, 244, 218),
    ),
    bodyLarge: TextStyle(
      color: Color.fromARGB(255, 160, 168, 176),
      fontWeight: FontWeight.w600,
      fontSize: 13,
    ),
    bodyMedium: TextStyle(
      color: Color.fromARGB(255, 55, 244, 218),
      fontWeight: FontWeight.w600,
      fontSize: 14,
    ),
  );
}
