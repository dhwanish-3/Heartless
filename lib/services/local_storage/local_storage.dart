import 'dart:convert';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/models/doctor.dart';
import 'package:heartless/shared/models/nurse.dart';
import 'package:heartless/shared/models/patient.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  // save user details
  static Future<bool> saveUser(AuthNotifier authNotifier) async {
    if (authNotifier.isLoggedIn == false) {
      return false;
    }
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('userType', userTypeToString(authNotifier.userType));

    String jsonUser = '';
    if (authNotifier.userType == UserType.patient) {
      jsonUser = jsonEncode(authNotifier.patient!.toMap());
    } else if (authNotifier.userType == UserType.doctor) {
      jsonUser = jsonEncode(authNotifier.doctor!.toMap());
    } else if (authNotifier.userType == UserType.nurse) {
      jsonUser = jsonEncode(authNotifier.nurse!.toMap());
    }
    if (jsonUser == '') {
      return false;
    }
    sp.setString('user', jsonUser);
    return true;
  }

  // get user details
  static Future<bool> getUser(AuthNotifier authNotifier) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String? jsonUser = sp.getString('user');

    if (jsonUser != null) {
      String? userType = sp.getString('userType');
      if (userType == null) {
        return false;
      }
      Map<String, dynamic> userMap = jsonDecode(jsonUser);
      authNotifier.setUserType(stringToUserType(userType));
      // set user details
      if (userType == userTypeToString(UserType.patient)) {
        authNotifier.setPatient(Patient.fromMap(userMap));
      } else if (userType == userTypeToString(UserType.doctor)) {
        authNotifier.setDoctor(Doctor.fromMap(userMap));
      } else if (userType == userTypeToString(UserType.nurse)) {
        authNotifier.setNurse(Nurse.fromMap(userMap));
      }
      return true;
    }
    return false;
  }

  // clear user details
  static Future<bool> clearUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove('user');
    sp.remove('userType');
    return true;
  }
}
