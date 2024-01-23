import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:heartless/services/exceptions/app_exceptions.dart';
import 'package:heartless/shared/Models/app_user.dart';
import 'package:heartless/shared/Models/patient.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';

class PatientAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const Duration _timeLimit = Duration(seconds: 10);
  String? _otp;

  // get patient using email
  Future<bool> getPatientDetailswithEmail(
      AuthNotifier authNotifier, String email) async {
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .where('email', isEqualTo: email)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          authNotifier.setPatient(Patient.fromMap(value.docs.first.data()));
        } else {
          return false;
        }
      }).timeout(_timeLimit);
      return true;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // get patient details from firebase
  Future<bool> getPateintDetails(AuthNotifier authNotifier) async {
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(authNotifier.patient!.uid)
          .get()
          .then((value) =>
              authNotifier.setPatient(Patient.fromMap(value.data()!)))
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

  // set patient details to firebase
  Future<bool> setPateintDetails(AuthNotifier authNotifier) async {
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(authNotifier.patient!.uid)
          .set(authNotifier.patient!.toMap())
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

  // initialize patient
  Future<bool> initializePatient(AuthNotifier authNotifier) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        authNotifier.patient!.uid = user.uid;
        await getPateintDetails(authNotifier).timeout(_timeLimit);
        authNotifier.setLoggedIn(true);
        return true;
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
      debugPrint('Google Sign In Started');
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw UnAutherizedException;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      UserCredential result = await _auth.signInWithCredential(credential);

      if (result.user != null) {
        // ! check if the user already had an account
        if (await getPatientDetailswithEmail(
            authNotifier, result.user!.email!)) {
          authNotifier.setLoggedIn(true);
          authNotifier.setUserType(UserType.patient);
          return true;
        } else {
          debugPrint(_auth.currentUser.toString());
          authNotifier.patient!.uid = result.user!.uid;
          authNotifier.patient!.email = result.user!.email!;
          authNotifier.patient!.name = result.user!.displayName!;
          authNotifier.patient!.imageUrl = result.user!.photoURL!;
          authNotifier.setLoggedIn(true);
          authNotifier.setUserType(UserType.patient);
          bool success =
              await setPateintDetails(authNotifier).timeout(_timeLimit);
          if (success) {
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

  // login for patient
  Future<bool> loginPatient(AuthNotifier authNotifier) async {
    try {
      await _auth
          .signInWithEmailAndPassword(
              email: authNotifier.patient!.email,
              password: authNotifier.patient!.password)
          .timeout(_timeLimit);

      User? user = _auth.currentUser;
      if (user != null) {
        authNotifier.patient!.uid = user.uid;
        bool success =
            await getPateintDetails(authNotifier).timeout(_timeLimit);
        if (success) {
          authNotifier.setLoggedIn(true);
          authNotifier.setUserType(UserType.patient);
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

  // signup for patient
  Future<bool> signUpPatient(AuthNotifier authNotifier) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
              email: authNotifier.patient!.email,
              password: authNotifier.patient!.password)
          .then((value) => authNotifier.patient!.uid = value.user!.uid)
          .timeout(_timeLimit);
      User? user = _auth.currentUser;
      if (user != null) {
        bool success =
            await setPateintDetails(authNotifier).timeout(_timeLimit);
        if (success) {
          authNotifier.setLoggedIn(true);
          authNotifier.setUserType(UserType.patient);
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

  // logout for patient
  Future<bool> logoutPatient(AuthNotifier authNotifier) async {
    try {
      await _auth.signOut().timeout(_timeLimit);
      authNotifier.setLoggedIn(false);
      authNotifier.setPatient(Patient());
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
          .sendPasswordResetEmail(email: authNotifier.patient!.email.toString())
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
      if (email != authNotifier.patient!.email) {
        throw FirebaseAuthException;
      }
      _otp = code; // saving it for later use
      return true;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
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
        authNotifier.patient!.password = newPassword;
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
