import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import 'package:heartless/backend/auth/auth.dart';
import "package:heartless/main.dart";
import "package:heartless/shared/Models/patient.dart";
import "package:heartless/shared/provider/auth_notifier.dart";
import "package:heartless/shared/provider/theme_provider.dart";
import 'package:heartless/widgets/otp_input_field.dart';
import "package:heartless/widgets/left_trailing_button.dart";
import "package:heartless/widgets/right_trailing_button.dart";
import "package:heartless/shared/provider/widget_provider.dart";

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final Auth _auth = Auth();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  //! must fetch userEmail from authNotifier
  final userEmail = "dhwanish";

  @override
  void dispose() {
    super.dispose();
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

    Future<bool> submitForm() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        bool success = await _auth.verifyOTP(authNotifier, _otpController.text);
        return success;
      } else {
        return false;
      }
    }

    void goBack() {
      Navigator.pop(
          context); //! idk what happens if this is the first page i.e. nothing to pop
    }

    void goToCreatePasswordPage() {
      Navigator.pushNamed(
          context, '/create_password'); // todo : add correct name
    }

    return Scaffold(
      resizeToAvoidBottomInset: false, //to prevent pixel overflow
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
          // Positioned(
          //   left: 20,
          //   top: 40,
          //   child: IconButton(
          //     icon: const Icon(Icons.brightness_6), // Icon to toggle theme
          //     onPressed: () {
          //       themeProvider.toggleThemeMode();
          //     },
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 120,
                ),
                SvgPicture.asset(
                  'assets/illustrations/forgot_pass.svg',
                  height: svgHeight,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Enter Verification Code',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  '''Enter code that we have sent to your email''',
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "${userEmail.substring(0, 2)}********@gmail.com",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(
                  height: 20,
                ),
                OtpWidget(otpController: _otpController),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(onTap: goBack, child: const LeftButton()),
                      GestureDetector(
                          onTap: () async {
                            if (await submitForm()) {
                              goToCreatePasswordPage();
                            }
                          },
                          child: const RightButton(text: 'Verify')),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
