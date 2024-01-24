import 'package:firebase_auth/firebase_auth.dart';
import 'package:heartless/backend/services/auth/patient_auth.dart';
import 'package:heartless/services/local_storage/local_storage.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';

class SplashServices {
  final _auth = FirebaseAuth.instance;

  Future<bool> hasLoggedIn(AuthNotifier authNotifier) async {
    final user = _auth.currentUser;
    if (user != null) {
      if (await LocalStorage().getUser(authNotifier)) {
        return true;
      } else {
        try {
          if (await PatientAuth().initializePatient(authNotifier)) {
            return true;
          } else {
            return false;
          }
        } catch (e) {
          print(e);
          return false;
        }
      }
    } else {
      return false;
    }
  }
}
