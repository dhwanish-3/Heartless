import 'package:flutter/material.dart';
import 'package:heartless/pages/auth/login_page.dart';
import 'package:heartless/pages/auth/signup_page.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:provider/provider.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WidgetNotifier>(
      builder: (context, widgetNotifier, _) {
        if (widgetNotifier.showLogin) {
          return const LoginPage();
        } else {
          return const SignUpPage();
        }
      },
    );
  }
}
