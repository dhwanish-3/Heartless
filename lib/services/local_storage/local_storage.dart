import 'dart:convert';
import 'package:heartless/shared/models/app_user.dart';
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

    String jsonUser = jsonEncode(authNotifier.appUser!.toMap());

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
      // set user details
      authNotifier.setUserType(stringToUserType(userType));
      authNotifier.setAppUser(AppUser.getInstanceFromMap(
          authNotifier.userType, jsonDecode(jsonUser)));
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
