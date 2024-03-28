import 'package:flutter/material.dart';

class Constants {
  static const appName = "HeartFul";
  static const primaryColor = Color.fromARGB(255, 52, 190, 171);
  static const darkPrimaryColor = Color.fromARGB(255, 212, 64, 64);
  static const cardColor = Color.fromARGB(255, 240, 240, 240);
  static const darkCardColor = Color.fromARGB(255, 50, 50, 50);
  static const lightPrimaryColor = Color.fromARGB(255, 202, 230, 226);
  static const customGray = Color.fromARGB(255, 160, 168, 176);
  static const notifColor = Color.fromARGB(255, 251, 188, 5);
  static const foodColor = Color.fromARGB(178, 255, 104, 56);
  static const medColor = Color.fromARGB(255, 125, 171, 247);
  static const exerciseColor = Color.fromARGB(191, 52, 168, 83);

  TextTheme textThemeLight = const TextTheme(
    displayLarge: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Colors.black,
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
      color: primaryColor,
      fontSize: 15,
    ),
    bodyLarge: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 20,
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
    ),
    titleSmall: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
  );

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
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 20,
    ),
    bodyMedium: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 16,
    ),
    headlineSmall: TextStyle(
      color: primaryColor,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
    titleSmall: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
  );
}
