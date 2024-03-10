import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:heartless/backend/services/auth/auth_service.dart';
import 'package:heartless/main.dart';
import 'package:heartless/pages/chat/select_chat.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';

// top level function for handling background messages
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  // todo: if message from chats, then have to navigate to chat page
  log('Titile: ${message.notification!.title}');
  log('Body: ${message.notification!.body}');
  log('Payload: ${message.data}');
}

class NotificationService {
  // for accessing firebase messaging (Push Notification)
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  // creating a channel for local notifications
  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
          'high_importance_channel', 'Important notifications',
          description: 'This channel is used for important notifications.',
          importance: Importance.high);

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // for handling notification both for foreground and background
  static void handleNotification(RemoteMessage? message) {
    if (message == null) {
      return;
    }
    log("These are the message details");
    log(message.toString());
    log(message.notification.toString());
    log(message.data.toString());
    log(message.notification!.body.toString());

    log("handleNotification: ${message.notification!.title}");
    navigatorKey.currentState!
        .push(MaterialPageRoute(builder: (context) => SelectChatPage()));
  }

  static Future<void> initPushNotifications() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    // handling notification when the app is in terminated state
    _firebaseMessaging.getInitialMessage().then(handleNotification);

    // handling click on notification when the app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(handleNotification);

    // handling background messages
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // handling notification when the app is in foreground
    FirebaseMessaging.onMessage.listen((message) {
      log("onMessage: this is foreground message");
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

  // initializing local notifications
  static Future<void> initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/logo');
    const initializationSettings =
        InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (notification) {
        log("local notification received");
        final message =
            RemoteMessage.fromMap(jsonDecode(notification.payload!));
        log("lets handle the notification");
        handleNotification(message);
      },
      // onDidReceiveBackgroundNotificationResponse: (notification) {
      //   log("local notification received tapped");
      //   final message =
      //       RemoteMessage.fromMap(jsonDecode(notification.payload!));
      //   log("lets handle the notification tapped");
      //   handleNotification(message);
      // },
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  // getting firebase push token
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
      String pushToken, String name, String chatId, String msg) async {
    try {
      final body = {
        "to": pushToken,
        "notification": {
          "title": name,
          "body": msg,
          "android_channel_id": "chats"
        },
        "data": {
          "chatId": chatId,
        },
      };

      final res =
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

  // to schedule a local notification
  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required String payload,
    required DateTime scheduledTime,
  }) async {
    try {
      initLocalNotifications();
      _localNotifications.getActiveNotifications().then((value) {
        log("Active Notifications: $value");
        for (var i = 0; i < value.length; i++) {
          log("Active Notification: ${value[i].id}");
        }
      });
      log("scheduling notification on");
      log(scheduledTime.toString());
      log("local time: " +
          tz.TZDateTime.from(scheduledTime, tz.local).toString());
      tz.initializeTimeZones();
      await _localNotifications.zonedSchedule(
          scheduledTime.hashCode,
          title,
          body,
          tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
          // tz.TZDateTime.from(scheduledTime, tz.local),
          NotificationDetails(
              android: AndroidNotificationDetails(
                  "_androidChannel.id", "_androidChannel.name",
                  channelDescription: "_androidChannel.description",
                  importance: Importance.max,
                  priority: Priority.high,
                  ticker: 'ticker')),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: payload);
    } catch (e) {
      log("Error in scheduling notification: $e");
    }
  }

  // show a simple notification
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _localNotifications.show(0, title, body, notificationDetails,
        payload: payload);
  }
}
