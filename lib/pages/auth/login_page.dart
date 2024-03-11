import "dart:developer";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:heartless/backend/controllers/auth_controller.dart";
import "package:heartless/backend/services/notifications/notification_services.dart";
import "package:heartless/main.dart";
import 'package:heartless/services/storage/local_storage.dart';
import "package:heartless/services/phone_auth/phone_auth.dart";
import 'package:heartless/shared/models/app_user.dart';
import "package:heartless/shared/provider/auth_notifier.dart";
import "package:heartless/shared/constants.dart";
import "package:heartless/widgets/auth/email_phone_toggle.dart";
import 'package:heartless/widgets/auth/google_button.dart';
import 'package:heartless/widgets/miscellaneous/left_trailing_button.dart';
import 'package:heartless/widgets/miscellaneous/right_trailing_button.dart';
import 'package:heartless/widgets/auth/text_input.dart';
import "package:heartless/shared/provider/widget_provider.dart";
import "package:intl_phone_field/intl_phone_field.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _phoneNumber = '';

  final AuthController _authController = AuthController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double svgHeight = 0.15 * screenHeight;
    double screenWidth = MediaQuery.of(context).size.width;
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    void goBack() {
      Navigator.pop(context);
    }

    void goHome() {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }

    // patient login
    Future<void> login() async {
      AppUser appUser = AppUser.getInstance(authNotifier.userType);
      log(appUser.toMap().toString());
      appUser.email = _emailController.text;
      appUser.password = _passwordController.text;
      authNotifier.setAppUser(appUser);
      log("During login: ");
      log(authNotifier.appUser!.toMap().toString());
      bool success = await _authController.login(authNotifier);
      if (success && context.mounted) {
        await LocalStorage.saveUser(authNotifier);
        NotificationServices.getFirebaseMessagingToken(authNotifier);
        goHome();
      }
    }

    void submitForm() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        widgetNotifier.setLoading(true);
        await login();
        widgetNotifier.setLoading(false);
      }
    }

    void phoneLoginSubmitForm() async {
      if (_phoneFormKey.currentState!.validate()) {
        widgetNotifier.setLoading(true);
        _phoneFormKey.currentState!.save();
        AppUser appUser = AppUser.getInstance(authNotifier.userType);
        appUser.phone = _phoneNumber;
        authNotifier.setAppUser(appUser);
        await PhoneAuth.loginWithPhone(
            authNotifier, widgetNotifier, _phoneNumber, context);
      }
    }

    void googleSignIn() async {
      bool success = await _authController.googleSignIn(authNotifier);
      if (success && context.mounted) {
        await LocalStorage.saveUser(authNotifier);
        NotificationServices.getFirebaseMessagingToken(authNotifier);
        goHome();
      }
    }

    void goToForgotPassword() {
      Navigator.pushNamed(context, '/forgotPassword'); // todo: fix this
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              bottom: 0,
              child: SvgPicture.asset(
                'assets/Icons/blueHeart.svg',
                height: screenHeight * 0.2,
              ),
            ),
            // Center(
            //   child:
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    SvgPicture.asset(
                      'assets/illustrations/login.svg',
                      height: svgHeight,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${userTypeToString(authNotifier.userType)} Login',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const ToggleButton(emailPhoneToggle: true),
                    const SizedBox(height: 10),
                    Consumer<WidgetNotifier>(builder: (context, value, child) {
                      return widgetNotifier.emailPhoneToggle == true
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                                        textEditingController:
                                            _passwordController,
                                        hintText: 'Enter your password',
                                        labelText: 'password',
                                        startIcon: 'assets/Icons/lock.svg',
                                        endIcon: 'assets/Icons/eyeClosed.svg',
                                        endIconAlt:
                                            'assets/Icons/eyeOpened.svg',
                                        passwordShown:
                                            widgetNotifier.passwordShown,
                                        textInputType:
                                            TextInputType.visiblePassword,
                                      );
                                    }),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: goToForgotPassword,
                                            child: Text(
                                              'Forgot Password?',
                                              textAlign: TextAlign.start,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Form(
                                  key: _phoneFormKey,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const SizedBox(height: 20),
                                      SizedBox(
                                        width: screenWidth * 0.82,
                                        child: IntlPhoneField(
                                          initialCountryCode: 'IN',
                                          decoration: InputDecoration(
                                            labelText: 'Phone Number',
                                            labelStyle: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                            ),
                                            counterText: '',
                                            border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15))),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(15))),
                                          ),
                                          onChanged: (phone) {
                                            _phoneNumber = phone.completeNumber;
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  )));
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: goBack, child: const LeftButton()),
                          GestureDetector(
                              onTap: widgetNotifier.emailPhoneToggle == true
                                  ? submitForm
                                  : phoneLoginSubmitForm,
                              child: const RightButton(text: 'Login')),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            widgetNotifier.toggleLoginSignup();
                          },
                          child: Text(
                            "Sign Up",
                            style: Theme.of(context).textTheme.headlineSmall,
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
                        const Text(
                          'OR',
                          style: TextStyle(
                            color: Constants.customGray,
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
                        child: InkWell(
                            onTap: googleSignIn,
                            child: GoogleButton(screenWidth: screenWidth))),
                    const SizedBox(
                      height: 20,
                    ),
//! this sizedBox has been added so as to ensure that the page would overflow the height constraints, to ensure proper ordering of elements
                    const SizedBox(height: 200),
                  ],
                ),
              ),
            ),
            // ),
          ],
        ),
      ),
    );
  }
}
