import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:heartless/backend/services/auth/auth_service.dart';
import 'package:heartless/pages/chat/contacts_page.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

// top level function for handling background messages
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log('Titile: ${message.notification!.title}');
  log('Body: ${message.notification!.body}');
  log('Payload: ${message.data}');
}

class NotificationServices {
  // for accessing firebase messaging (Push Notification)
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  // for handling notification when the app is in foreground
  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
          'high_importance_channel', 'Important notifications',
          description: 'This channel is used for important notifications.',
          importance: Importance.high);

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static void handleNotification(RemoteMessage? message) {
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
    FirebaseMessaging.onMessage.listen((message) {
      final RemoteNotification? notification = message.notification;
      if (notification == null) {
        return;
      }
      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/logo',
          )),
          payload: jsonEncode(message.toMap()));
    });
  }

  static Future<void> initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/logo');
    const initializationSettings =
        InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (notification) {
      final message = RemoteMessage.fromMap(jsonDecode(notification.payload!));
      handleNotification(message);
    });

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
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
  }

  // for sending push notification
  static Future<void> sendPushNotification(
      String pushToken, String name, String msg) async {
    try {
      final body = {
        "to": pushToken,
        "notification": {
          "title": name, // our name should be send
          "body": msg,
          "android_channel_id": "chats"
        },
        // "data": {
        //   "some_data": "User ID: ${me.id}",
        // },
      };

      var res =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    'key=AAAA99vPjLI:APA91bEDV71H7ganL2VnDFH3Q-ayUcthoYlncoyBOOIYqtxz45BocGGL_sSk1SZlq_UIdAYQesmL-VRBcTfFAk58xpSqmUWOG6f9sMK_sy7X_gFNMIzKr3_FJjq_Nyr0IygpiGHOTzGG'
              },
              body: jsonEncode(body));
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }
}
