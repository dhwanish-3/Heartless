import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:heartless/services/exceptions/app_exceptions.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/models/nurse.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';

class NurseAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _nurseRef = FirebaseFirestore.instance.collection('Nurses');
  static const Duration _timeLimit = Duration(seconds: 10);
  String? _otp;

  // get nurse using email
  Future<bool> getNurseDetailswithEmail(
      AuthNotifier authNotifier, String email) async {
    try {
      return await _nurseRef
          .where('email', isEqualTo: email)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          authNotifier.setNurse(Nurse.fromMap(value.docs.first.data()));
          return true;
        } else {
          return false;
        }
      }).timeout(_timeLimit);
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // get nurse details from firebase
  Future<bool> getNurseDetails(AuthNotifier authNotifier) async {
    try {
      return await _nurseRef.doc(authNotifier.nurse!.uid).get().then((value) {
        if (value.exists && value.data() != null) {
          authNotifier.setNurse(Nurse.fromMap(value.data()!));
          return true;
        } else {
          return false;
        }
      }).timeout(_timeLimit);
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // set nurse details to firebase
  Future<bool> setNurseDetails(AuthNotifier authNotifier) async {
    try {
      await _nurseRef
          .doc(authNotifier.nurse!.uid)
          .set(authNotifier.nurse!.toMap())
          .timeout(_timeLimit);
      return true;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // initialize nurse
  Future<bool> initializeNurse(AuthNotifier authNotifier) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        authNotifier.nurse!.uid = user.uid;
        if (await getNurseDetails(authNotifier)) {
          authNotifier.setLoggedIn(true);
          return true;
        } else {
          authNotifier.setLoggedIn(false);
          return false;
        }
      } else {
        authNotifier.setLoggedIn(false);
        return false;
      }
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  /* Authentication */

  // google sign in
  Future<bool> googleSignIn(AuthNotifier authNotifier) async {
    final googleSignIn = GoogleSignIn();
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw UnAutherizedException;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      UserCredential result = await _auth.signInWithCredential(credential);

      if (result.user != null) {
        // * check if the user already had an account
        if (await getNurseDetailswithEmail(authNotifier, result.user!.email!)) {
          authNotifier.setLoggedIn(true);
          authNotifier.setUserType(UserType.nurse);
          return true;
        } else {
          // * if not then create a new account
          authNotifier.setNurse(Nurse());
          authNotifier.nurse!.uid = result.user!.uid;
          authNotifier.nurse!.email = result.user!.email!;
          authNotifier.nurse!.name = result.user!.displayName!;
          authNotifier.nurse!.imageUrl = result.user!.photoURL!;
          bool success = await setNurseDetails(authNotifier);
          if (success) {
            authNotifier.setLoggedIn(true);
            authNotifier.setUserType(UserType.nurse);
            authNotifier.setNurse(authNotifier.nurse!);
            return true;
          } else {
            await _auth.signOut();
            throw SocketException;
          }
        }
      } else {
        throw SocketException;
      }
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // login for nurse
  Future<bool> loginNurse(AuthNotifier authNotifier) async {
    try {
      await _auth
          .signInWithEmailAndPassword(
              email: authNotifier.nurse!.email,
              password: authNotifier.nurse!.password)
          .timeout(_timeLimit);

      User? user = _auth.currentUser;
      if (user != null) {
        authNotifier.nurse!.uid = user.uid;
        bool success = await getNurseDetails(authNotifier).timeout(_timeLimit);
        if (success) {
          authNotifier.setLoggedIn(true);
          authNotifier.setUserType(UserType.nurse);
          authNotifier.setAppUser(authNotifier.nurse!);
          return true;
        } else {
          await _auth.signOut();
          throw SocketException;
        }
      } else {
        throw SocketException;
      }
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // signup for nurse
  Future<bool> signUpNurse(AuthNotifier authNotifier) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
              email: authNotifier.nurse!.email,
              password: authNotifier.nurse!.password)
          .then((value) => authNotifier.nurse!.uid = value.user!.uid)
          .timeout(_timeLimit);
      User? user = _auth.currentUser;
      if (user != null) {
        bool success = await setNurseDetails(authNotifier).timeout(_timeLimit);
        if (success) {
          authNotifier.setLoggedIn(true);
          authNotifier.setUserType(UserType.nurse);
          authNotifier.setAppUser(authNotifier.nurse!);
          return true;
        } else {
          await _auth // ! Let us hope that this never happens
              .signOut(); // !i.e. user created at auth but not able to set to firestore
          return false;
        }
      } else {
        throw SocketException;
      }
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // logout for nurse
  Future<bool> logoutNurse(AuthNotifier authNotifier) async {
    try {
      await _auth.signOut().timeout(_timeLimit);
      authNotifier.setLoggedIn(false);
      authNotifier.setNurse(Nurse());
      authNotifier.setAppUser(AppUser());
      return true;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  /* Forgot Password */
  // send password reset email
  Future<bool> sendPasswordResetEmail(AuthNotifier authNotifier) async {
    try {
      await _auth
          .sendPasswordResetEmail(email: authNotifier.nurse!.email.toString())
          .timeout(_timeLimit);
      return true;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // verify otp
  Future<bool> verifyOTP(AuthNotifier authNotifier, String code) async {
    try {
      //! Really do have a doubt on which method to use for verification
      //! verifyPasswordResetCode or confirmPasswordReset
      String email =
          await _auth.verifyPasswordResetCode(code).timeout(_timeLimit);
      if (email == authNotifier.nurse!.email) {
        _otp = code; // saving it for later use
        return true;
      } else {
        throw FirebaseAuthException;
      }
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // set new password
  Future<bool> setNewPassword(
      AuthNotifier authNotifier, String newPassword) async {
    try {
      if (_otp != null) {
        await _auth
            .confirmPasswordReset(code: _otp!, newPassword: newPassword)
            .timeout(_timeLimit);

        _otp = null; // clearing otp
        authNotifier.nurse!.password = newPassword;
        return true;
      } else {
        throw FirebaseAuthException;
      }
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }
}
