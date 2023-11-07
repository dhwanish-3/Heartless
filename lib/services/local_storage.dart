import 'dart:convert';

import 'package:heartless/shared/Models/patient.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  // save user details
  Future<bool> saveUser(AuthNotifier authNotifier) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('userType', authNotifier.userType);
    String jsonUser = jsonEncode(authNotifier.patient.toMap());

    sp.setString('user', jsonUser);
    return true;
  }

  // get user details
  Future<bool> getUser(AuthNotifier authNotifier) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String? jsonUser = sp.getString('user');

    if (jsonUser != null) {
      String? userType = sp.getString('userType');
      Map<String, dynamic> userMap = jsonDecode(jsonUser);
      if (userType == 'patient') {
        authNotifier.setUserType(userType!);
        authNotifier.setPatient(Patient.fromMap(userMap));
      }
      return true;
    }
    return false;
  }

  // clear user details
  Future<bool> clearUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove('user');
    sp.remove('userType');
    return true;
  }
}
