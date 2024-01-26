import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:heartless/backend/controllers/patient_controller.dart";
import "package:heartless/main.dart";
import "package:heartless/shared/provider/auth_notifier.dart";
import "package:heartless/shared/provider/theme_provider.dart";
import 'package:heartless/widgets/miscellaneous/left_trailing_button.dart';
import 'package:heartless/widgets/miscellaneous/right_trailing_button.dart';
import 'package:heartless/widgets/auth/text_input.dart';
import "package:heartless/shared/provider/widget_provider.dart";

class CreatePasswordPage extends StatefulWidget {
  const CreatePasswordPage({super.key});

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final PatientController _patientController = PatientController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _confirmPasswordController.dispose();
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

    void goBack() {
      Navigator.pop(
          context); //! idk what happens if this is the first page i.e. nothing to pop
    }

    void goToLoginPage() {
      Navigator.pushNamed(context, '/login'); // todo : add correct name
    }

    Future<void> submitForm() async {
      if (_formKey.currentState!.validate()) {
        if (_passwordController.text != _confirmPasswordController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Passwords do not match'),
            ),
          );
        }
        _formKey.currentState!.save();
        bool success = await _patientController.setNewPassword(
            authNotifier, _passwordController.text);
        if (success) {
          goToLoginPage();
        }
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
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
            Container(
              height: screenHeight,
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
                    'Create New Passsword',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  SizedBox(
                    width: screenWidth * 0.8,
                    child: Text(
                      'create new password to login',
                      style: Theme.of(context).textTheme.labelMedium,
                      textAlign: TextAlign.center,
                    ),
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
                          Consumer<WidgetNotifier>(
                              builder: (context, value, child) {
                            return TextFieldInput(
                              textEditingController: _confirmPasswordController,
                              hintText: 'Confirm your password',
                              labelText: 'confirm password',
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
                            child: const RightButton(text: 'Login')),
                      ],
                    ),
                  ),
                  // const SizedBox(
                  //   height: 120,
                  // ),
                  //
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
