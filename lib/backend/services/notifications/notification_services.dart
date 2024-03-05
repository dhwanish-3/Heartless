import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:heartless/backend/services/auth/auth.dart';
import 'package:heartless/pages/chat/contacts_page.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log('Titile: ${message.notification!.title}');
  log('Body: ${message.notification!.body}');
  log('Payload: ${message.data}');
}

class NotificationServices {
  // for accessing firebase messaging (Push Notification)
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static handleNotification(RemoteMessage? message) {
    if (message == null) {
      return;
    }
    GlobalKey<NavigatorState>().currentState!.push(
          MaterialPageRoute(
            builder: (context) => const ContactsPage(),
          ),
        );
  }

  static Future<void> initPushNotifications() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    _firebaseMessaging.getInitialMessage().then(handleNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(handleNotification);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  static Future<String?> getFirebaseMessagingToken(
      AuthNotifier authNotifier) async {
    await _firebaseMessaging.requestPermission();

    await _firebaseMessaging.getToken().then((t) {
      if (t != null) {
        log('Push Token: $t');
        // setting the pushToken for the user
        authNotifier.appUser!.pushToken = t;
        // updating the user pushToken in firebase
        AuthService().setUserDetails(authNotifier);
        return t;
      } else {
        null;
      }
    });
    return null;

    // for handling foreground messages
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   log('Got a message whilst in the foreground!');
    //   log('Message data: ${message.data}');

    //   if (message.notification != null) {
    //     log('Message also contained a notification: ${message.notification}');
    //   }
    // });
  }
}
