import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:heartless/services/exceptions/app_exceptions.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/models/doctor.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';

class DoctorAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _doctorRef = FirebaseFirestore.instance.collection('Doctors');
  static const Duration _timeLimit = Duration(seconds: 10);
  String? _otp;

  // get doctor using email
  Future<bool> getDoctorDetailswithEmail(
      AuthNotifier authNotifier, String email) async {
    try {
      return await _doctorRef
          .where('email', isEqualTo: email)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          authNotifier.setDoctor(Doctor.fromMap(value.docs.first.data()));
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

  // get doctor details from firebase
  Future<bool> getDoctorDetails(AuthNotifier authNotifier) async {
    try {
      return await _doctorRef.doc(authNotifier.doctor!.uid).get().then((value) {
        if (value.exists && value.data() != null) {
          authNotifier.setDoctor(Doctor.fromMap(value.data()!));
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

  // set doctor details to firebase
  Future<bool> setDoctorDetails(AuthNotifier authNotifier) async {
    try {
      await _doctorRef
          .doc(authNotifier.doctor!.uid)
          .set(authNotifier.doctor!.toMap())
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

  // initialize doctor
  Future<bool> initializeDoctor(AuthNotifier authNotifier) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        authNotifier.doctor!.uid = user.uid;
        if (await getDoctorDetails(authNotifier)) {
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
        if (await getDoctorDetailswithEmail(
            authNotifier, result.user!.email!)) {
          authNotifier.setLoggedIn(true);
          authNotifier.setUserType(UserType.doctor);
          authNotifier.setAppUser(authNotifier.doctor!);
          return true;
        } else {
          // * if not then create a new account
          authNotifier.setDoctor(Doctor());
          authNotifier.doctor!.uid = result.user!.uid;
          authNotifier.doctor!.email = result.user!.email!;
          authNotifier.doctor!.name = result.user!.displayName!;
          authNotifier.doctor!.imageUrl = result.user!.photoURL!;
          bool success = await setDoctorDetails(authNotifier);
          if (success) {
            authNotifier.setLoggedIn(true);
            authNotifier.setUserType(UserType.doctor);
            authNotifier.setAppUser(authNotifier.doctor!);
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

  // login for doctor
  Future<bool> loginDoctor(AuthNotifier authNotifier) async {
    try {
      await _auth
          .signInWithEmailAndPassword(
              email: authNotifier.doctor!.email,
              password: authNotifier.doctor!.password)
          .timeout(_timeLimit);

      User? user = _auth.currentUser;
      if (user != null) {
        authNotifier.doctor!.uid = user.uid;
        bool success = await getDoctorDetails(authNotifier).timeout(_timeLimit);
        if (success) {
          authNotifier.setLoggedIn(true);
          authNotifier.setUserType(UserType.doctor);
          authNotifier.setAppUser(authNotifier.doctor!);
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

  // signup for doctor
  Future<bool> signUpDoctor(AuthNotifier authNotifier) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
              email: authNotifier.doctor!.email,
              password: authNotifier.doctor!.password)
          .then((value) => authNotifier.doctor!.uid = value.user!.uid)
          .timeout(_timeLimit);
      User? user = _auth.currentUser;
      if (user != null) {
        bool success = await setDoctorDetails(authNotifier).timeout(_timeLimit);
        if (success) {
          authNotifier.setLoggedIn(true);
          authNotifier.setUserType(UserType.doctor);
          authNotifier.setAppUser(authNotifier.doctor!);
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

  // logout for doctor
  Future<bool> logoutDoctor(AuthNotifier authNotifier) async {
    try {
      await _auth.signOut().timeout(_timeLimit);
      authNotifier.setLoggedIn(false);
      authNotifier.setDoctor(Doctor());
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
          .sendPasswordResetEmail(email: authNotifier.doctor!.email.toString())
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
      if (email == authNotifier.doctor!.email) {
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
        authNotifier.doctor!.password = newPassword;
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
