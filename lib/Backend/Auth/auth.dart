import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:heartless/services/exceptions/app_exceptions.dart';
import 'package:heartless/shared/Models/patient.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const Duration _timeLimit = Duration(seconds: 10);
  String? _verificationId;
  String? _otp;

  // get patient details from firebase
  Future<bool> getPateintDetails(AuthNotifier authNotifier) async {
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(authNotifier.patient.uid)
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
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  // set patient details to firebase
  Future<bool> setPateintDetails(AuthNotifier authNotifier) async {
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(authNotifier.patient.uid)
          .set(authNotifier.patient.toMap())
          .timeout(_timeLimit);
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

  // login for patient
  Future<bool> loginPatient(AuthNotifier authNotifier) async {
    try {
      await _auth
          .signInWithEmailAndPassword(
              email: authNotifier.patient.email,
              password: authNotifier.patient.password)
          .timeout(_timeLimit);

      User? user = _auth.currentUser;
      if (user != null) {
        authNotifier.patient.uid = user.uid;
        bool success =
            await getPateintDetails(authNotifier).timeout(_timeLimit);
        if (success) {
          authNotifier.setLoggedIn(true);
          return true;
        } else {
          await _auth.signOut();
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
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  // signup for patient
  Future<bool> signUpPatient(AuthNotifier authNotifier) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
              email: authNotifier.patient.email,
              password: authNotifier.patient.password)
          .then((value) => authNotifier.patient.uid = value.user!.uid)
          .timeout(_timeLimit);

      bool success = await setPateintDetails(authNotifier).timeout(_timeLimit);
      if (success) {
        authNotifier.setLoggedIn(true);
        return true;
      } else {
        await _auth // ! Let us hope that this never happens
            .signOut(); // !i.e. user created at auth but not able to set to firestore
        return false;
      }
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

  // initialize patient
  Future<bool> initializePatient(AuthNotifier authNotifier) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        authNotifier.patient.uid = user.uid;
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
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
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
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  /* Forgot Password */
  // send password reset email
  Future<bool> sendPasswordResetEmail(AuthNotifier authNotifier) async {
    try {
      await _auth
          .sendPasswordResetEmail(email: authNotifier.patient.email.toString())
          .timeout(_timeLimit);
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

  // send password reset message to phone number
  Future<bool> sendPasswordResetMessagetoPhone(
      AuthNotifier authNotifier) async {
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: authNotifier.patient.phone,
          verificationCompleted: (_) {},
          verificationFailed: (firebaseException) {
            throw firebaseException;
          },
          codeSent: (String vID, int? token) {
            _verificationId = vID;
          },
          codeAutoRetrievalTimeout: (e) {
            throw TimeoutException;
          });
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

  // verify otp
  Future<bool> verifyOTP(AuthNotifier authNotifier, String code) async {
    try {
      //! Really do have a doubt on which method to use for verification
      //! verifyPasswordResetCode or confirmPasswordReset
      String email =
          await _auth.verifyPasswordResetCode(code).timeout(_timeLimit);
      if (email != authNotifier.patient.email) {
        return false;
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
  Future<bool> setNewPassword(String newPassword) async {
    try {
      if (_otp != null) {
        _auth
            .confirmPasswordReset(code: _otp!, newPassword: newPassword)
            .timeout(_timeLimit);
        return true;
      } else {
        return false;
      }
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
}
