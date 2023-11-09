import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:heartless/Backend/Auth/auth.dart";
import "package:heartless/main.dart";
import "package:heartless/shared/auth_notifier.dart";
import "package:heartless/shared/constants.dart";
import "package:heartless/shared/provider/theme_provider.dart";
import "package:heartless/widgets/GoogleButton.dart";
import "package:heartless/widgets/left_trailing_button.dart";
import "package:heartless/widgets/right_trailing_button.dart";
import "package:heartless/widgets/text_input.dart";
import "package:heartless/shared/provider/widget_provider.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double svgHeight = 0.15 * screenHeight;
    double screenWidth = MediaQuery.of(context).size.width;
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);
    final themeProvider = Provider.of<ThemeNotifier>(context);
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: SvgPicture.asset(
              'assets/Icons/blueHeart.svg',
              height: screenHeight * 0.2,
            ),
          ),
          Positioned(
            left: 20,
            top: 40,
            child: IconButton(
              icon: const Icon(Icons.brightness_6), // Icon to toggle theme
              onPressed: () {
                themeProvider.toggleThemeMode();
              },
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
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
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextFieldInput(
                            textEditingController: _emailController,
                            hintText: 'Enter your email',
                            labelText: 'email',
                            startIcon: 'assets/Icons/Email.svg',
                            textInputType: TextInputType.emailAddress,
                          ),
                          Consumer<WidgetNotifier>(
                              builder: (context, value, child) {
                            return TextFieldInput(
                              textEditingController: _passwordController,
                              hintText: 'Enter your password',
                              labelText: 'password',
                              startIcon: 'assets/Icons/lock.svg',
                              endIcon: 'assets/Icons/eyeClosed.svg',
                              endIconAlt: 'assets/Icons/eyeOpened.svg',
                              passwordShown: widgetNotifier.passwordShown,
                              textInputType: TextInputType.visiblePassword,
                            );
                          }),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('Forgot Password?',
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {}, child: const LeftButton()),
                          GestureDetector(
                              onTap: () {
                                Auth().loginPatient(authNotifier);
                              },
                              child: const RightButton()),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: Constants().customGray,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 10, 0),
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                        Text(
                          'OR',
                          style: TextStyle(
                            color: Constants().customGray,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 30, 0),
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.all(20),
                        child: GoogleButton(screenWidth: screenWidth)),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
