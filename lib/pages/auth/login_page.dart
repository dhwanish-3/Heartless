import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:heartless/backend/controllers/nurse_controller.dart";
import "package:heartless/backend/controllers/patient_controller.dart";
import "package:heartless/main.dart";
import "package:heartless/shared/models/app_user.dart";
import "package:heartless/shared/models/nurse.dart";
import 'package:heartless/shared/models/patient.dart';
import "package:heartless/shared/provider/auth_notifier.dart";
import "package:heartless/shared/constants.dart";
import 'package:heartless/widgets/auth/google_button.dart';
import 'package:heartless/widgets/miscellaneous/left_trailing_button.dart';
import 'package:heartless/widgets/miscellaneous/right_trailing_button.dart';
import 'package:heartless/widgets/auth/text_input.dart';
import "package:heartless/shared/provider/widget_provider.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // for patient, nurse and doctor login purpose respectively
  final PatientController _patientController = PatientController();
  final NurseController _nurseController = NurseController();
  // todo: add doctor controller

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
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);

    void goBack() {
      Navigator.pop(context);
    }

    void goToPatientHome() {
      Navigator.pushNamed(context, '/patientHome'); // todo : add correct name
    }

    void goToNurseHome() {
      Navigator.pushNamed(context, '/nurseHome'); // todo : add correct name
    }

    // patient login
    void patientLogin() async {
      debugPrint('patient login');
      Patient patient = Patient();
      patient.email = _emailController.text;
      patient.password = _passwordController.text;
      authNotifier.setPatient(patient);
      bool success = await _patientController.login(authNotifier);
      if (success && context.mounted) {
        debugPrint('Logged in ${authNotifier.patient!.uid}');
        goToPatientHome();
      }
    }

    // nurse login
    void nurseLogin() async {
      debugPrint('nurse login');
      Nurse nurse = Nurse();
      nurse.email = _emailController.text;
      nurse.password = _passwordController.text;
      authNotifier.setNurse(nurse);
      bool success = await _nurseController.login(authNotifier);
      if (success && context.mounted) {
        debugPrint('Logged in ${authNotifier.nurse!.uid}');
        goToNurseHome();
      }
    }

    void submitForm() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (widgetNotifier.userType == UserType.patient) {
          patientLogin();
        } else if (widgetNotifier.userType == UserType.nurse) {
          nurseLogin();
        } // todo : add doctor
      }
    }

    void googleSignIn() async {
      if (widgetNotifier.userType == UserType.patient) {
        bool success = await _patientController.googleSignIn(authNotifier);
        if (success && context.mounted) {
          goToPatientHome();
        }
      } else if (widgetNotifier.userType == UserType.nurse) {
        bool success = await _nurseController.googleSignIn(authNotifier);
        if (success && context.mounted) {
          goToNurseHome();
        }
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
                        '${userTypeToString(widgetNotifier.userType)} Login',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Form(
                          key: _formKey,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
