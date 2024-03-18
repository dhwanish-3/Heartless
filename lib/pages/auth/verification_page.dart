import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:heartless/services/phone_auth/phone_auth.dart";
import "package:heartless/shared/provider/auth_notifier.dart";
import "package:heartless/shared/provider/widget_provider.dart";
import 'package:heartless/widgets/auth/otp_input_field.dart';
import 'package:heartless/widgets/miscellaneous/left_trailing_button.dart';
import 'package:heartless/widgets/miscellaneous/right_trailing_button.dart';
import "package:provider/provider.dart";

class VerificationPage extends StatefulWidget {
  //! email or phone number should be appropriately sent from page
  final String? verificationId;
  const VerificationPage({super.key, this.verificationId});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double svgHeight = 0.15 * screenHeight;
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);

    void goBack() {
      Navigator.pop(
          context); //! idk what happens if this is the first page i.e. nothing to pop
    }

    void goHome() {
      Navigator.pushNamedAndRemoveUntil(
          context, '/home', (route) => false); // todo : add correct name
    }

    Future<void> submitForm() async {
      if (_formKey.currentState!.validate() && widget.verificationId != null) {
        _formKey.currentState!.save();
        widgetNotifier.setLoading(true);
        bool success = await PhoneAuth.verifyOTP(
            authNotifier, widget.verificationId!, _otpController.text);
        widgetNotifier.setLoading(false);
        if (success) {
          goHome();
        }
      }
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
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            child: Form(
              key: _formKey,
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
                    '''Enter code that we have sent to your phone number''',
                    style: Theme.of(context).textTheme.labelMedium,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    authNotifier.appUser!.phone ?? "**********",
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: goBack, child: const LeftButton()),
                        GestureDetector(
                            onTap: submitForm,
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
          ),
        ],
      ),
    );
  }
}
