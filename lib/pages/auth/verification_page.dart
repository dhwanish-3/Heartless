import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import 'package:heartless/backend/services/auth/auth_service.dart';
import "package:heartless/backend/services/notifications/notification_services.dart";
import "package:heartless/main.dart";
import "package:heartless/services/local_storage/local_storage.dart";
import "package:heartless/services/utils/toast_message.dart";
import "package:heartless/shared/provider/auth_notifier.dart";
import "package:heartless/shared/provider/widget_provider.dart";
import 'package:heartless/widgets/auth/otp_input_field.dart';
import 'package:heartless/widgets/miscellaneous/left_trailing_button.dart';
import 'package:heartless/widgets/miscellaneous/right_trailing_button.dart';

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

  final FirebaseAuth _auth = FirebaseAuth.instance;
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
        try {
          bool alreadyExists = await AuthService().getUserDetailswithPhone(
              authNotifier, authNotifier.appUser!.phone!);
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: widget.verificationId ?? "ERROR",
              smsCode: _otpController.text);
          User? user = (await _auth.signInWithCredential(credential)).user;
          if (alreadyExists) {
            if (user != null) {
              await LocalStorage.saveUser(authNotifier);
              ToastMessage().showSuccess("Logged in successfully");
              widgetNotifier.setLoading(false);
              goHome();
            } else {
              await _auth.signOut();
              ToastMessage().showError("User does not exist");
            }
          } else {
            if (user != null) {
              authNotifier.appUser!.uid = user.uid;
              await AuthService().setUserDetails(authNotifier);
              await LocalStorage.saveUser(authNotifier);
              ToastMessage().showSuccess("Logged in successfully");
              widgetNotifier.setLoading(false);
              goHome();
            } else {
              await _auth.signOut();
              ToastMessage().showError("User does not exist");
            }
          }
          NotificationServices.getFirebaseMessagingToken(authNotifier);
        } catch (e) {
          ToastMessage().showError(e.toString());
        }
        widgetNotifier.setLoading(false);
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
