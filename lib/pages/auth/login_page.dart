import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:heartless/widgets/text_input.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double svgHeight = 0.15 * screenHeight;
    return Scaffold(
      // appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/illustrations/login.svg',
              height: svgHeight,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'Enter your email',
                  labelText: 'email',
                  startIcon: 'assets/Icons/Email.svg',
                  textInputType: TextInputType.emailAddress,
                ),
                TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: 'Enter your password',
                  labelText: 'password',
                  startIcon: 'assets/Icons/lock.svg',
                  endIcon: 'assets/Icons/eyeClosed.svg',
                  endIconAlt: 'assets/Icons/eyeOpened.svg',
                  isPass: true,
                  textInputType: TextInputType.visiblePassword,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
