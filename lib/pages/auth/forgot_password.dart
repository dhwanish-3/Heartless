import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:heartless/backend/controllers/doctor_controller.dart";
import "package:heartless/backend/controllers/nurse_controller.dart";
import "package:heartless/backend/controllers/patient_controller.dart";
import "package:heartless/main.dart";
import 'package:heartless/shared/models/app_user.dart';
import "package:heartless/shared/models/doctor.dart";
import 'package:heartless/shared/models/nurse.dart';
import 'package:heartless/shared/models/patient.dart';
import "package:heartless/shared/provider/auth_notifier.dart";
import "package:heartless/shared/provider/widget_provider.dart";
import 'package:heartless/widgets/miscellaneous/left_trailing_button.dart';
import 'package:heartless/widgets/miscellaneous/right_trailing_button.dart';
import 'package:heartless/widgets/auth/text_input.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  // for patient, nurse and doctor login purpose respectively
  final PatientController _patientController = PatientController();
  final NurseController _nurseController = NurseController();
  final DoctorController _doctorController = DoctorController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double svgHeight = 0.15 * screenHeight;
    double screenWidth = MediaQuery.of(context).size.width;
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);

    void goBack() {
      Navigator.pop(context);
    }

    void goToLoginPage() {
      Navigator.pushNamed(context, '/login');
    }

    // patient forgot password
    void patientForgotPassword() async {
      widgetNotifier.setLoading(true);
      Patient patient = Patient();
      patient.email = _emailController.text;
      authNotifier.setPatient(patient);

      if (await _patientController.sendResetEmail(authNotifier)) {
        // since verification by otp input is not yet functional user is redirected to login page
        widgetNotifier.setLoading(false);
        goToLoginPage();
      } else {
        // in case the sendResetEmail function returns false
        widgetNotifier.setLoading(false);
      }
    }

    void nurseForgotPassword() async {
      widgetNotifier.setLoading(true);
      Nurse nurse = Nurse();
      nurse.email = _emailController.text;
      authNotifier.setNurse(nurse);
      if (await _nurseController.sendResetEmail(authNotifier)) {
        // since verification by otp input is not yet functional user is redirected to login page
        widgetNotifier.setLoading(false);
        goToLoginPage();
      } else {
        // in case the sendResetEmail function returns false
        widgetNotifier.setLoading(false);
      }
    }

    void doctorForgotPassword() async {
      widgetNotifier.setLoading(true);
      Doctor doctor = Doctor();
      doctor.email = _emailController.text;
      authNotifier.setDoctor(doctor);
      if (await _doctorController.sendResetEmail(authNotifier)) {
        // since verification by otp input is not yet functional user is redirected to login page
        widgetNotifier.setLoading(false);
        goToLoginPage();
      } else {
        // in case the sendResetEmail function returns false
        widgetNotifier.setLoading(false);
      }
    }

    Future<void> submitForm() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (authNotifier.userType == UserType.patient) {
          patientForgotPassword();
        } else if (authNotifier.userType == UserType.nurse) {
          nurseForgotPassword();
        } else if (authNotifier.userType == UserType.doctor) {
          doctorForgotPassword();
        }
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
              Container(
                height: screenHeight,
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
                        'Forgot Your Password?',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: screenWidth * 0.8,
                        child: Text(
                          '''Enter your email we will send an email with instructions to reset your password''',
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
                        child: TextFieldInput(
                          textEditingController: _emailController,
                          hintText: 'Enter your email',
                          labelText: 'email',
                          startIcon: 'assets/Icons/Email.svg',
                          textInputType: TextInputType.emailAddress,
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
                                child: const RightButton(text: 'Submit')),
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
        ),
      ),
    );
  }
}
