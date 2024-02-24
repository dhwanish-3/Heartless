import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:heartless/backend/constants.dart';
import 'package:heartless/services/exceptions/app_exceptions.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/models/patient.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';

class PatientAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _patientRef = FirebaseFirestore.instance.collection('Patients');
  static const Duration _timeLimit = Duration(seconds: 10);
  String? _otp;
  String? _verificationId;

  // get patient using email
  Future<bool> getPatientDetailswithEmail(
      AuthNotifier authNotifier, String email) async {
    try {
      return await _patientRef
          .where('email', isEqualTo: email)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          authNotifier.setPatient(Patient.fromMap(value.docs.first.data()));
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

  // get patient using phone number
  Future<bool> getPatientDetailswithPhone(
      AuthNotifier authNotifier, String phone) async {
    try {
      return await _patientRef
          .where('phone', isEqualTo: phone)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          authNotifier.setPatient(Patient.fromMap(value.docs.first.data()));
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

  // get patient details from firebase
  Future<bool> getPateintDetails(AuthNotifier authNotifier) async {
    try {
      return await _patientRef
          .doc(authNotifier.patient!.uid)
          .get()
          .then((value) {
        if (value.exists && value.data() == null) {
          authNotifier.setPatient(Patient.fromMap(value.data()!));
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

  // set patient details to firebase
  Future<bool> setPatientDetails(AuthNotifier authNotifier) async {
    try {
      await _patientRef
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
  //! found some errors in this method
  Future<bool> initializePatient(AuthNotifier authNotifier) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        authNotifier.setPatient(Patient());
        authNotifier.patient!.uid = user.uid;
        if (await getPateintDetails(authNotifier).timeout(_timeLimit)) {
          authNotifier.setLoggedIn(true);
          authNotifier.setUserType(UserType.patient);
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
  Future<bool> signInWithPhoneCredential(
      {required AuthNotifier authNotifier,
      String? otp,
      PhoneAuthCredential? credential}) async {
    try {
      PhoneAuthCredential createdCredential = credential ??
          PhoneAuthProvider.credential(
            verificationId: _verificationId!,
            smsCode: otp ?? (throw UnAutherizedException()),
          );
      await _auth.signInWithCredential(createdCredential).then((value) async {
        if (value.user != null) {
          if (await getPatientDetailswithPhone(
              authNotifier, value.user!.phoneNumber!)) {
            authNotifier.setLoggedIn(true);
            authNotifier.setUserType(UserType.patient);
            authNotifier.setAppUser(authNotifier.patient!);
          } else {
            authNotifier.setPatient(Patient());
            authNotifier.patient!.uid = value.user!.uid;
            authNotifier.patient!.name = authNotifier.patient!.name;
            await setPatientDetails(authNotifier).timeout(_timeLimit);
            authNotifier.setLoggedIn(true);
            authNotifier.setUserType(UserType.patient);
            authNotifier.setAppUser(authNotifier.patient!);
          }
        }
      });
      _verificationId = null;
      return true;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // phone sign in
  Future<PhoneAuth> phoneSignIn(AuthNotifier authNotifier) async {
    PhoneAuth returnValue = PhoneAuth.pending;
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: authNotifier.patient!.phone!,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await signInWithPhoneCredential(
              authNotifier: authNotifier, credential: credential);
          returnValue = PhoneAuth.autoVerified;
        },
        verificationFailed: (FirebaseAuthException e) {
          returnValue = PhoneAuth.verificationFailed;
          throw UnAutherizedException();
        },
        codeSent: (String verificationId, int? resendToken) {
          returnValue = PhoneAuth.codeSent;
          // authNotifier.setVerificationId(verificationId);
          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          returnValue = PhoneAuth.codeAutoRetrievalTimeOut;
          // authNotifier.setVerificationId(verificationId);
        },
      );
      return returnValue;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

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
        if (await getPatientDetailswithEmail(
            authNotifier, result.user!.email!)) {
          authNotifier.setLoggedIn(true);
          authNotifier.setUserType(UserType.patient);
          authNotifier.setAppUser(authNotifier.patient!);
          return true;
        } else {
          // * if not then create a new account
          authNotifier.setPatient(Patient());
          authNotifier.patient!.uid = result.user!.uid;
          authNotifier.patient!.email = result.user!.email!;
          authNotifier.patient!.name = result.user!.displayName!;
          authNotifier.patient!.imageUrl = result.user!.photoURL!;
          bool success =
              await setPatientDetails(authNotifier).timeout(_timeLimit);
          if (success) {
            authNotifier.setLoggedIn(true);
            authNotifier.setUserType(UserType.patient);
            authNotifier.setAppUser(authNotifier.patient!);
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
          authNotifier.setAppUser(authNotifier.patient!);
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
            await setPatientDetails(authNotifier).timeout(_timeLimit);
        if (success) {
          authNotifier.setLoggedIn(true);
          authNotifier.setUserType(UserType.patient);
          authNotifier.setAppUser(authNotifier.patient!);
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
