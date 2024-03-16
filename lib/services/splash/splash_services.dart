import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:heartless/backend/services/misc/connect_users.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';

class SplashServices {
  final _auth = FirebaseAuth.instance;

  Future<bool> getUserFromFirebase(AuthNotifier authNotifier) async {
    final user = _auth.currentUser;
    AppUser? appUser;
    if (user != null) {
      log("User exists");
      appUser = await ConnectUsers.getUserDetails(user.uid);
      if (appUser != null) {
        authNotifier.setAppUser(appUser);
        log("User data fetched");
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
