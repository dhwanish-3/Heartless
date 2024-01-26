import 'package:flutter/material.dart';
import 'package:heartless/pages/testing_page.dart';
import 'package:heartless/services/routes/routes.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/shared/provider/theme_provider.dart';
import 'package:provider/provider.dart';
export 'package:provider/provider.dart'; //* Exporting provider package to all other files
import 'package:heartless/shared/provider/widget_provider.dart';
import "package:firebase_core/firebase_core.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'Heart Recovery',
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.lightTheme,
      darkTheme: themeNotifier.darkTheme,
      themeMode: ThemeNotifier.themeMode,
      // initialRoute: '/',
      home: const TestingPage(),
      onGenerateRoute: Routes.generateRoutes,
    );
  }

// ! Make a new clss for test themes
}
