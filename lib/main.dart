import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heartless/backend/services/notifications/notification_services.dart';
import 'package:heartless/services/routes/routes.dart';
import 'package:heartless/shared/provider/analytics_provider.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/shared/provider/theme_provider.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Locking the orientation to portrait
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // initializing firebase
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyCpzMaQ8VnK9aBfI2i8P8wwcxqeRWYm9fY',
        appId: '1:1064544734386:android:daf184d0cc0ad786c74dab',
        messagingSenderId: 'sendid',
        projectId: 'heartless-17b56',
        storageBucket: 'heartless-17b56.appspot.com',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  // initializing push notifications
  await NotificationService.initPushNotifications();

  // initializing local notifications
  await NotificationService.initLocalNotifications();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthNotifier()),
      ChangeNotifierProvider(create: (_) => WidgetNotifier()),
      ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ChangeNotifierProvider(create: (_) => AnalyticsNotifier()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Heart Recovery',
          debugShowCheckedModeBanner: false,
          theme: themeNotifier.lightTheme,
          darkTheme: themeNotifier.darkTheme,
          themeMode: ThemeNotifier.themeMode,
          initialRoute: '/',
          onGenerateRoute: Routes.generateRoutes,
          navigatorKey: navigatorKey,
        );
      },
    );
  }
}
