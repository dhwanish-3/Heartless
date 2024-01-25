import 'package:flutter/material.dart';
import 'package:heartless/pages/auth/dummy_home.dart';
import 'package:heartless/pages/auth/splash_screen.dart';
import 'package:heartless/pages/auth/login_page.dart';
import 'package:heartless/pages/auth/signup_page.dart';
import 'package:heartless/services/auth/login_register_toggle.dart';
import 'package:heartless/services/routes/route_names.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        // todo: add landing page
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      // * auth routes * //
      case RouteNames.loginPatient:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case RouteNames.signupPatient:
        return MaterialPageRoute(builder: (_) => const SignUpPage());

      case RouteNames.loginDoctor:
        // todo: add login page for doctor
        return MaterialPageRoute(builder: (_) => Container());

      case RouteNames.loginOrSignup:
        return MaterialPageRoute(builder: (_) => const LoginOrRegister());
      // ! Patient routes ! //
      case RouteNames.patientHome:
        return MaterialPageRoute(builder: (_) => const DummyHome());
      default:
        return MaterialPageRoute(builder: (_) => Container());
    }
  }
}
