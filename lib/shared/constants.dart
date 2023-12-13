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
        color: customGray,
        fontSize: 15,
      ),
      labelSmall: TextStyle(
        color: customGray,
        fontSize: 15,
      ),
      bodyLarge: TextStyle(
        color: customGray,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
      bodyMedium: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
      headlineSmall: TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ));

  TextTheme textThemeDark = const TextTheme(
      displayLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      labelMedium: TextStyle(
        color: customGray,
        fontSize: 15,
      ),
      labelSmall: TextStyle(
        color: primaryColor,
        fontSize: 15,
      ),
      bodyLarge: TextStyle(
        color: customGray,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
      bodyMedium: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
      headlineSmall: TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ));
}
