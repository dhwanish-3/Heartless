import 'dart:ui';

import 'package:heartless/services/enums/color_theme.dart';
import 'package:heartless/services/enums/user_type.dart';
import 'package:heartless/shared/models/app_user.dart';

class Patient extends AppUser {
  List<String> nurses = [];
  List<String> doctors = [];

  Patient() {
    userType = UserType.patient;
    // todo: add a default image for patient
    imageUrl =
        'https://firebasestorage.googleapis.com/v0/b/heartless-17b56.appspot.com/o/static%2FShelly_SS%202024-05-05%20at%2010.19.28%E2%80%AFPM.png?alt=media&token=c2d67f86-0b5d-4213-8ec7-79804d45cb9f';
  }

  Patient.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    name = map['name'];
    imageUrl = map['imageUrl'];
    email = map['email'];
    phone = map['phone'];
    password = map['password'];
    userType = UserType.values[map['userType']];
    isOnline = map['isOnline'];
    pushToken = map['pushToken'] ?? '';
    lastSeen = DateTime.parse(map['lastSeen'] ?? DateTime.now());
    nurses = map['nurses'] is Iterable ? List.from(map['nurses']) : [];
    doctors = map['doctors'] is Iterable ? List.from(map['doctors']) : [];
    theme = ColorTheme.values[map['theme'] ?? ColorTheme.Default.index];
    brightness = Brightness.values[map['brightness'] ?? Brightness.light.index];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'imageUrl': imageUrl,
      'email': email,
      'phone': phone,
      'password': password,
      'userType': userType.index,
      'isOnline': isOnline,
      'pushToken': pushToken,
      'lastSeen': lastSeen.toString(),
      'nurses': nurses,
      'doctors': doctors,
      'theme': theme.index,
      'brightness': brightness.index,
    };
  }
}
