import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:heartless/services/exceptions/app_exceptions.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _userRef = FirebaseFirestore.instance.collection('Users');

  static const Duration _timeLimit = Duration(seconds: 10);

  // get user using email
  Future<bool> getUserDetailswithEmail(
      AuthNotifier authNotifier, String email) async {
    try {
      return await _userRef
          .where('email', isEqualTo: email)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          // * check if the user is of the same type
          if (value.docs.first.data()['userType'] !=
              authNotifier.userType.index) {
            throw UnAutherizedException('User Type Mismatch');
          }
          authNotifier.setAppUser(AppUser.getInstanceFromMap(
              authNotifier.userType, value.docs.first.data()));
          return true;
        } else {
          return false;
        }
      }).timeout(_timeLimit);
    } on FirebaseAuthException {
      throw UnAutherizedException('User not found');
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // get patient using phone number
  Future<bool> getUserDetailswithPhone(
      AuthNotifier authNotifier, String phone) async {
    try {
      return await _userRef
          .where('phone', isEqualTo: phone)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          // * check if the user is of the same type
          if (value.docs.first.data()['userType'] !=
              authNotifier.userType.index) {
            throw UnAutherizedException('User Type Mismatch');
          }
          authNotifier.setAppUser(AppUser.getInstanceFromMap(
              authNotifier.userType, value.docs.first.data()));
          return true;
        } else {
          return false;
        }
      }).timeout(_timeLimit);
    } on FirebaseAuthException {
      throw UnAutherizedException("Firebase Exception");
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // get patient details from firebase
  Future<bool> getUserDetails(AuthNotifier authNotifier) async {
    try {
      return await _userRef.doc(authNotifier.appUser!.uid).get().then((value) {
        if (value.exists && value.data() != null) {
          // * check if the user is of the same type
          if (value.data()!['userType'] != authNotifier.userType.index) {
            throw UnAutherizedException('User Type Mismatch');
          }
          authNotifier.setAppUser(
              AppUser.getInstanceFromMap(authNotifier.userType, value.data()!));
          return true;
        } else {
          return false;
        }
      }).timeout(_timeLimit);
    } on FirebaseAuthException {
      throw UnAutherizedException("Firebase Exception");
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // set user details to firebase // !requires that appUser to be assigned the instance of the user according to userType
  Future<bool> setUserDetails(AuthNotifier authNotifier) async {
    try {
      await _userRef
          .doc(authNotifier.appUser!.uid)
          .set(authNotifier.appUser!.toMap())
          .timeout(_timeLimit);
      return true;
    } on FirebaseAuthException {
      throw UnAutherizedException("Firebase Exception");
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  //? note: this is not user anywhere
  // initialize user // !required to have authNotifier.userType set!
  Future<bool> initializeUser(AuthNotifier authNotifier) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        authNotifier.setAppUser(AppUser());
        authNotifier.appUser!.uid = user.uid;
        if (await getUserDetails(authNotifier).timeout(_timeLimit)) {
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
      throw UnAutherizedException("Firebase Exception");
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
        throw UnAutherizedException("googleUser is null");
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      UserCredential result = await _auth.signInWithCredential(credential);

      if (result.user != null) {
        // * check if the user already had an account
        if (await getUserDetailswithEmail(authNotifier, result.user!.email!)) {
          authNotifier.setLoggedIn(true);
          return true;
        } else {
          // * if not then create a new account
          AppUser appUser = AppUser.getInstance(authNotifier.userType);
          appUser.uid = result.user!.uid;
          appUser.email = result.user!.email!;
          appUser.name = result.user!.displayName!;
          appUser.imageUrl = result.user!.photoURL!;
          authNotifier.setAppUser(appUser);
          bool success = await setUserDetails(authNotifier).timeout(_timeLimit);
          if (success) {
            authNotifier.setLoggedIn(true);
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
      throw UnAutherizedException("Firebase Exception");
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // login ! requires authNotifier.appUser to be assigned the instance of the user according to userType
  Future<bool> login(AuthNotifier authNotifier) async {
    try {
      await _auth
          .signInWithEmailAndPassword(
              email: authNotifier.appUser!.email,
              password: authNotifier.appUser!.password)
          .timeout(_timeLimit);

      User? user = _auth.currentUser;
      if (user != null) {
        authNotifier.appUser!.uid = user.uid;
        bool success = await getUserDetails(authNotifier).timeout(_timeLimit);
        if (success) {
          authNotifier.setLoggedIn(true);
          return true;
        } else {
          await _auth.signOut();
          throw SocketException;
        }
      } else {
        throw SocketException;
      }
    } on FirebaseAuthException {
      throw UnAutherizedException("Firebase Exception");
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // signup ! requires authNotifier.appUser to be assigned the instance of the user according to userType
  Future<bool> signUp(AuthNotifier authNotifier) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
              email: authNotifier.appUser!.email,
              password: authNotifier.appUser!.password)
          .then((value) => authNotifier.appUser!.uid = value.user!.uid)
          .timeout(_timeLimit);
      User? user = _auth.currentUser;
      if (user != null) {
        bool success = await setUserDetails(authNotifier).timeout(_timeLimit);
        if (success) {
          authNotifier.setLoggedIn(true);
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
      throw UnAutherizedException("Firebase Exception");
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // logout
  Future<bool> logout(AuthNotifier authNotifier) async {
    try {
      await _auth.signOut().timeout(_timeLimit);
      authNotifier.setLoggedIn(false);
      authNotifier.setAppUser(AppUser());
      return true;
    } on FirebaseAuthException {
      throw UnAutherizedException("Firebase Exception");
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
          .sendPasswordResetEmail(email: authNotifier.appUser!.email.toString())
          .timeout(_timeLimit);
      return true;
    } on FirebaseAuthException {
      throw UnAutherizedException("Firebase Exception");
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }
}
