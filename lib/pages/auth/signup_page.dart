import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:heartless/backend/controllers/auth_controller.dart";
import "package:heartless/backend/services/auth/auth.dart";
import "package:heartless/main.dart";
import "package:heartless/pages/auth/verification_page.dart";
import "package:heartless/services/local_storage/local_storage.dart";
import "package:heartless/services/utils/toast_message.dart";
import 'package:heartless/shared/models/app_user.dart';
import "package:heartless/shared/constants.dart";
import "package:heartless/shared/provider/auth_notifier.dart";
import "package:heartless/widgets/auth/email_phone_toggle.dart";
import 'package:heartless/widgets/auth/google_button.dart';
import 'package:heartless/widgets/miscellaneous/left_trailing_button.dart';
import 'package:heartless/widgets/miscellaneous/right_trailing_button.dart';
import 'package:heartless/widgets/auth/text_input.dart';
import "package:heartless/shared/provider/widget_provider.dart";
import "package:intl_phone_field/intl_phone_field.dart";

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final AuthController _authController = AuthController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String _phoneNumber = '';

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
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
      Navigator.pushNamed(context, '/home');
    }

    // patient signup
    Future<void> signUp() async {
      AppUser appUser = AppUser.getInstance(authNotifier.userType);
      appUser.name = _nameController.text;
      appUser.email = _emailController.text;
      appUser.password = _passwordController.text;
      authNotifier.setAppUser(appUser);
      bool success = await _authController.signUp(authNotifier);
      if (success && context.mounted) {
        await LocalStorage.saveUser(authNotifier);
        goHome();
      }
    }

    void submitForm() async {
      if (_formKey.currentState!.validate()) {
        widgetNotifier.setLoading(true);
        _formKey.currentState!.save();
        await signUp();
        widgetNotifier.setLoading(false);
      }
    }

    // patient login with phone
    Future<void> loginWithPhone(String phoneNumber) async {
      AppUser appUser = AppUser.getInstance(authNotifier.userType);
      appUser.name = _nameController.text;
      appUser.phone = _phoneNumber;
      authNotifier.setAppUser(appUser);
      bool alreadyExists = await AuthService()
          .getUserDetailswithPhone(authNotifier, phoneNumber);
      if (alreadyExists) {
        authNotifier.setAppUser(AppUser());
        ToastMessage().showError("User already exists. Please login");
        widgetNotifier.setLoading(false);
        return;
      }
      _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            User? user = (await _auth.signInWithCredential(credential)).user;
            if (user != null) {
              authNotifier.appUser!.uid = user.uid;
              await AuthService().setUserDetails(authNotifier);
              await LocalStorage.saveUser(authNotifier);
              ToastMessage().showSuccess("Logged in successfully");
              widgetNotifier.setLoading(false);
              goHome();
            } else {
              await _auth.signOut();
              ToastMessage().showError("Failed to login");
            }
          } catch (e) {
            ToastMessage().showError(e.toString());
          }
          widgetNotifier.setLoading(false);
        },
        verificationFailed: (FirebaseAuthException e) {
          ToastMessage().showError("Verification failed");
          widgetNotifier.setLoading(false);
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationPage(
                verificationId: verificationId,
              ),
            ),
          );
          widgetNotifier.setLoading(false);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          ToastMessage().showError("Code auto retrieval timeout");
          widgetNotifier.setLoading(false);
        },
      );
    }

    void phoneLoginSubmitForm() async {
      if (_phoneFormKey.currentState!.validate() &&
          _phoneNumber.isNotEmpty &&
          _phoneNumber.length == 13) {
        _phoneFormKey.currentState!.save();
        widgetNotifier.setLoading(true);
        await loginWithPhone(_phoneNumber);
      }
    }

    void googleSignIn() async {
      bool success = await _authController.googleSignIn(authNotifier);
      if (success && context.mounted) {
        await LocalStorage.saveUser(authNotifier);
        goHome();
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              child: SvgPicture.asset(
                'assets/Icons/heartRightbottom.svg',
                height: screenHeight * 0.2,
              ),
            ),

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
                    const SizedBox(height: 40),
                    SvgPicture.asset(
                      'assets/illustrations/signup.svg',
                      height: svgHeight,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${userTypeToString(authNotifier.userType)} SignUp',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(
                      height: 15,
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
                                      textEditingController: _nameController,
                                      hintText: 'Enter your email',
                                      labelText: 'name',
                                      startIcon: 'assets/Icons/user.svg',
                                      textInputType: TextInputType.name,
                                    ),
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
                                      TextFieldInput(
                                        textEditingController: _nameController,
                                        hintText: 'Enter your email',
                                        labelText: 'name',
                                        startIcon: 'assets/Icons/user.svg',
                                        textInputType: TextInputType.name,
                                      ),
                                      const SizedBox(height: 10),
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
                                            print(phone.completeNumber);
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
                              child: const RightButton(text: 'SignUp')),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            widgetNotifier.toggleLoginSignup();
                          },
                          child: Text(
                            "Log in",
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
                    //! this sizedBox has been added so as to ensure that the page would overflow the height constraints, to ensure proper ordering of elements
                    const SizedBox(height: 150),
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
