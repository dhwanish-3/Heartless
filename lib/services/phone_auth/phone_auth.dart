import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heartless/backend/services/auth/auth_service.dart';
import 'package:heartless/backend/services/notifications/notification_services.dart';
import 'package:heartless/pages/auth/verification_page.dart';
import 'package:heartless/services/utils/toast_message.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/shared/provider/widget_provider.dart';

class PhoneAuth {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static void goHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  // login with phone
  static Future<void> loginWithPhone(
      AuthNotifier authNotifier,
      WidgetNotifier widgetNotifier,
      String phoneNumber,
      BuildContext context) async {
    try {
      bool alreadyExists = await AuthService()
          .getUserDetailswithPhone(authNotifier, phoneNumber);
      if (!alreadyExists) {
        ToastMessage().showError("User does not exist");
        widgetNotifier.setLoading(false);
        return;
      }
      await _auth
          .verifyPhoneNumber(
            phoneNumber: phoneNumber,
            verificationCompleted: (PhoneAuthCredential credential) async {
              try {
                User? user =
                    (await _auth.signInWithCredential(credential)).user;
                if (user != null) {
                  ToastMessage().showSuccess("Logged in successfully");
                  widgetNotifier.setLoading(false);
                  NotificationService.getFirebaseMessagingToken(authNotifier);
                  if (context.mounted) {
                    goHome(context);
                  }
                } else {
                  await _auth.signOut();
                  ToastMessage().showError("User does not exist");
                }
              } catch (e) {
                ToastMessage().showError(e.toString());
              }
              widgetNotifier.setLoading(false);
            },
            verificationFailed: (FirebaseAuthException e) {
              ToastMessage().showError("Verification failed");
              widgetNotifier.setLoading(false);
            },
            codeSent: (String verificationId, int? resendToken) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VerificationPage(
                    verificationId: verificationId,
                  ),
                ),
              );
              widgetNotifier.setLoading(false);
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              ToastMessage().showError("Code auto retrieval timeout");
              widgetNotifier.setLoading(false);
            },
          )
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      widgetNotifier.setLoading(false);
      ToastMessage().showError(e.toString());
    }
  }

  // signup with phone
  static Future<void> signUpWithPhone(
      AuthNotifier authNotifier,
      WidgetNotifier widgetNotifier,
      String phoneNumber,
      BuildContext context) async {
    try {
      bool alreadyExists = await AuthService()
          .getUserDetailswithPhone(authNotifier, phoneNumber);
      if (alreadyExists) {
        authNotifier.setAppUser(AppUser());
        ToastMessage().showError("User already exists. Please login");
        widgetNotifier.setLoading(false);
        return;
      }
      await _auth
          .verifyPhoneNumber(
            phoneNumber: phoneNumber,
            verificationCompleted: (PhoneAuthCredential credential) async {
              try {
                User? user =
                    (await _auth.signInWithCredential(credential)).user;
                if (user != null) {
                  authNotifier.appUser!.uid = user.uid;
                  await AuthService().setUserDetails(authNotifier);
                  ToastMessage().showSuccess("Logged in successfully");
                  widgetNotifier.setLoading(false);
                  NotificationService.getFirebaseMessagingToken(authNotifier);
                  if (context.mounted) {
                    goHome(context);
                  }
                } else {
                  await _auth.signOut();
                  ToastMessage().showError("Failed to login");
                }
              } catch (e) {
                ToastMessage().showError(e.toString());
              }
              widgetNotifier.setLoading(false);
            },
            verificationFailed: (FirebaseAuthException e) {
              ToastMessage().showError("Verification failed");
              widgetNotifier.setLoading(false);
            },
            codeSent: (String verificationId, int? resendToken) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VerificationPage(
                    verificationId: verificationId,
                  ),
                ),
              );
              widgetNotifier.setLoading(false);
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              ToastMessage().showError("Code auto retrieval timeout");
              widgetNotifier.setLoading(false);
            },
          )
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      widgetNotifier.setLoading(false);
      ToastMessage().showError(e.toString());
    }
  }

  static Future<bool> verifyOTP(
      AuthNotifier authNotifier, String verificationId, String otp) async {
    try {
      bool alreadyExists = await AuthService()
          .getUserDetailswithPhone(authNotifier, authNotifier.appUser!.phone!);
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      User? user = (await _auth.signInWithCredential(credential)).user;
      if (alreadyExists) {
        if (user != null) {
          ToastMessage().showSuccess("Logged in successfully");
          NotificationService.getFirebaseMessagingToken(authNotifier);
          return true;
        } else {
          await _auth.signOut();
          ToastMessage().showError("User does not exist");
          return false;
        }
      } else {
        if (user != null) {
          authNotifier.appUser!.uid = user.uid;
          await AuthService().setUserDetails(authNotifier);
          ToastMessage().showSuccess("Logged in successfully");
          NotificationService.getFirebaseMessagingToken(authNotifier);
          return true;
        } else {
          await _auth.signOut();
          ToastMessage().showError("User does not exist");
          return false;
        }
      }
    } catch (e) {
      ToastMessage().showError(e.toString());
      return false;
    }
  }
}
