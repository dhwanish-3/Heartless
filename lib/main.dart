import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heartless/backend/services/notifications/notification_services.dart';
import 'package:heartless/services/routes/routes.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/shared/provider/theme_provider.dart';
import 'package:provider/provider.dart';
export 'package:provider/provider.dart'; //* Exporting provider package to all other files
import 'package:heartless/shared/provider/widget_provider.dart';
import "package:firebase_core/firebase_core.dart";

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Locking the orientation to portrait
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // initializing firebase
  await Firebase.initializeApp();

  // initializing push notifications
  await NotificationService.initPushNotifications();

  // initializing local notifications
  await NotificationService.initLocalNotifications();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthNotifier()),
      ChangeNotifierProvider(create: (_) => WidgetNotifier()),
      ChangeNotifierProvider(create: (_) => ThemeNotifier()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier =
        Provider.of<ThemeNotifier>(context, listen: false);
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
  }
}
