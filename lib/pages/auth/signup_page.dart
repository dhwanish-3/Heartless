import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:heartless/backend/controllers/patient_controller.dart";
import "package:heartless/main.dart";
import 'package:heartless/shared/models/patient.dart';
import "package:heartless/shared/constants.dart";
import "package:heartless/shared/provider/auth_notifier.dart";
import 'package:heartless/widgets/auth/google_button.dart';
import 'package:heartless/widgets/miscellaneous/left_trailing_button.dart';
import 'package:heartless/widgets/miscellaneous/right_trailing_button.dart';
import 'package:heartless/widgets/auth/text_input.dart';
import "package:heartless/shared/provider/widget_provider.dart";

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final PatientController _patientController = PatientController();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
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
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    void goBack() {
      Navigator.pop(
          context); //! idk what happens if this is the first page i.e. nothing to pop
    }

    void goToHome() {
      Navigator.pushNamed(context, '/patientHome'); // todo : add correct name
    }

    void goToLoginPage() {
      Navigator.pushNamed(context, '/loginPatient'); // todo : add correct name
    }

    void submitForm() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        Patient? patient = Patient();
        patient.email = _emailController.text;
        patient.password = _passwordController.text;
        authNotifier.setPatient(patient);
        bool success = await _patientController.signUp(authNotifier);
        if (success && context.mounted) {
          debugPrint('Signed up ${authNotifier.patient!.uid}');
          goToHome();
        }
      }
    }

    void googleSignIn() async {
      bool success = await _patientController.googleSignIn(authNotifier);
      if (success && context.mounted) {
        goToHome();
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
                        'assets/illustrations/signup.svg',
                        height: svgHeight,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'SignUp',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(
                        height: 40,
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
