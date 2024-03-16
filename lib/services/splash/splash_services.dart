import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:heartless/services/storage/local_storage.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';

class SplashServices {
  final _auth = FirebaseAuth.instance;

  Future<bool> hasLoggedIn(AuthNotifier authNotifier) async {
    final user = _auth.currentUser;
    if (user != null) {
      log("User exists. Checking local storage.");
      if (await LocalStorage.getUser(authNotifier)) {
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
