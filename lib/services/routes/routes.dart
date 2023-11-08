import 'package:flutter/material.dart';
import 'package:heartless/pages/auth/login_page.dart';
import 'package:heartless/services/routes/route_names.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        // todo: add landing page
        return MaterialPageRoute(builder: (_) => Container());

      // * auth routes * //
      case RouteNames.loginPatient:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case RouteNames.loginDoctor:
        // todo: add login page for doctor
        return MaterialPageRoute(builder: (_) => Container());

      // ! Patient routes ! //
      default:
        return MaterialPageRoute(builder: (_) => Container());
    }
  }
}
