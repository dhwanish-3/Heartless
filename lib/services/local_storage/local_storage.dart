import 'dart:convert';
import 'package:heartless/shared/Models/app_user.dart';
import 'package:heartless/shared/Models/doctor.dart';
import 'package:heartless/shared/Models/nurse.dart';
import 'package:heartless/shared/Models/patient.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  // save user details
  Future<bool> saveUser(AuthNotifier authNotifier) async {
    if (authNotifier.isLoggedIn == false) {
      return false;
    }
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('userType', userTypeToString(authNotifier.userType));

    String jsonUser = '';
    if (authNotifier.userType == UserType.patient) {
      jsonUser = jsonEncode(authNotifier.patient!.toMap());
    }
    //todo: (test) add more user types here => mostly done
    else if (authNotifier.userType == UserType.doctor) {
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
  Future<bool> getUser(AuthNotifier authNotifier) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String? jsonUser = sp.getString('user');

    if (jsonUser != null) {
      String? userType = sp.getString('userType');
      Map<String, dynamic> userMap = jsonDecode(jsonUser);
      if (userType == 'patient') {
        authNotifier.setUserType(stringToUserType(userType!));
        authNotifier.setPatient(Patient.fromMap(userMap));
      }
      // todo: (test) add more user types here
      else if (userType == 'doctor') {
        authNotifier.setUserType(stringToUserType(userType!));
        authNotifier.setDoctor(Doctor.fromMap(userMap));
      } else if (userType == 'nurse') {
        authNotifier.setUserType(stringToUserType(userType!));
        authNotifier.setNurse(Nurse.fromMap(userMap));
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
