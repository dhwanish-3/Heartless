import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heartless/services/app_exceptions.dart';
import 'package:heartless/shared/Models/patient.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const Duration timeLimit = Duration(seconds: 10);

  // get patient details from firebase
  Future<bool> getPateintDetails(AuthNotifier authNotifier) async {
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(authNotifier.patient.uid)
          .get()
          .then((value) =>
              authNotifier.setPatient(Patient.fromMap(value.data()!)))
          .timeout(timeLimit);
      return true;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    } catch (e) {
      print(e);
    }
    return false;
  }

  // set patient details to firebase
  Future<bool> setPateintDetails(AuthNotifier authNotifier) async {
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(authNotifier.patient.uid)
          .set(authNotifier.patient.toMap());
      return true;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    } catch (e) {
      print(e);
    }
    return false;
  }

  // login for patient
  Future<bool> loginPatient(AuthNotifier authNotifier) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: authNotifier.patient.email!,
          password: authNotifier.patient.password!);

      User? user = _auth.currentUser;
      if (user != null) {
        authNotifier.patient.uid = user.uid;
        await getPateintDetails(authNotifier);
        authNotifier.setLoggedIn(true);
        return true;
      } else {
        authNotifier.setLoggedIn(false);
        return false;
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    } catch (e) {
      print(e);
    }
    return false;
  }

  // signup for patient
  Future<bool> signUpPatient(AuthNotifier authNotifier) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
              email: authNotifier.patient.email!,
              password: authNotifier.patient.password!)
          .then((value) => authNotifier.patient.uid = value.user!.uid);

      await setPateintDetails(authNotifier);
      authNotifier.setLoggedIn(true);
      return true;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    } catch (e) {
      print(e);
    }
    return false;
  }

  // initialize patient
  Future<bool> initializePatient(AuthNotifier authNotifier) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        authNotifier.patient.uid = user.uid;
        await getPateintDetails(authNotifier);
        authNotifier.setLoggedIn(true);
        return true;
      } else {
        authNotifier.setLoggedIn(false);
        return false;
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    } catch (e) {
      print(e);
    }
    return false;
  }

  // logout for patient
  Future<bool> logoutPatient(AuthNotifier authNotifier) async {
    try {
      await _auth.signOut();
      authNotifier.setLoggedIn(false);
      authNotifier.setPatient(Patient());
      return true;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    } catch (e) {
      print(e);
    }
    return false;
  }
}
