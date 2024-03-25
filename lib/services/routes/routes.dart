import 'package:flutter/material.dart';
import 'package:heartless/pages/auth/choose_user_type.dart';
import 'package:heartless/pages/auth/create_password.dart';
import 'package:heartless/pages/auth/forgot_password.dart';
import 'package:heartless/pages/auth/login_page.dart';
import 'package:heartless/pages/auth/login_register_toggle.dart';
import 'package:heartless/pages/auth/signup_page.dart';
import 'package:heartless/pages/auth/splash_screen.dart';
import 'package:heartless/pages/auth/verification_page.dart';
import 'package:heartless/pages/home/home_page.dart';
import 'package:heartless/services/routes/route_names.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        // todo: add landing page
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteNames.choosUserType:
        return MaterialPageRoute(builder: (_) => const ChooseUserPage());

      // * auth routes * //
      case RouteNames.loginOrSignup:
        return MaterialPageRoute(builder: (_) => const LoginOrRegister());
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case RouteNames.signup:
        return MaterialPageRoute(builder: (_) => const SignUpPage());

      case RouteNames.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
      case RouteNames.verification:
        return MaterialPageRoute(builder: (_) => const VerificationPage());
      case RouteNames.resetPassword:
        return MaterialPageRoute(builder: (_) => const CreatePasswordPage());

      // * common routes * //
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      // ! Patient routes ! //

      // ! Nurse routes ! //

      // ! Doctor routes ! //

      default:
        return MaterialPageRoute(builder: (_) => Container());
    }
  }
}
