import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:heartless/backend/controllers/doctor_controller.dart";
import "package:heartless/backend/controllers/nurse_controller.dart";
import "package:heartless/backend/controllers/patient_controller.dart";
import "package:heartless/main.dart";
import "package:heartless/services/local_storage/local_storage.dart";
import 'package:heartless/shared/models/app_user.dart';
import "package:heartless/shared/models/doctor.dart";
import 'package:heartless/shared/models/nurse.dart';
import 'package:heartless/shared/models/patient.dart';
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

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  // for patient, nurse and doctor login purpose respectively
  final PatientController _patientController = PatientController();
  final NurseController _nurseController = NurseController();
  final DoctorController _doctorController = DoctorController();

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

    void goToPatientHome() {
      Navigator.pushNamed(context, '/patientHome'); // todo : add correct name
    }

    void goToNurseHome() {
      Navigator.pushNamed(context, '/nurseHome'); // todo : add correct name
    }

    void goToDoctorHome() {
      Navigator.pushNamed(context, '/doctorHome'); // todo : add correct name
    }

    // patient signup
    Future<void> patientSignUp() async {
      Patient patient = Patient();
      patient.name = _nameController.text;
      patient.email = _emailController.text;
      patient.password = _passwordController.text;
      authNotifier.setPatient(patient);
      bool success = await _patientController.signUp(authNotifier);
      if (success && context.mounted) {
        await LocalStorage.saveUser(authNotifier);
        goToPatientHome();
      }
    }

    // nurse signup
    Future<void> nurseSignUp() async {
      Nurse nurse = Nurse();
      nurse.name = _nameController.text;
      nurse.email = _emailController.text;
      nurse.password = _passwordController.text;
      authNotifier.setNurse(nurse);
      bool success = await _nurseController.signUp(authNotifier);
      if (success && context.mounted) {
        await LocalStorage.saveUser(authNotifier);
        goToNurseHome();
      }
    }

    // doctor signup
    Future<void> doctorSignUp() async {
      Doctor doctor = Doctor();
      doctor.name = _nameController.text;
      doctor.email = _emailController.text;
      doctor.password = _passwordController.text;
      authNotifier.setDoctor(doctor);
      bool success = await _doctorController.signUp(authNotifier);
      if (success && context.mounted) {
        await LocalStorage.saveUser(authNotifier);
        goToDoctorHome();
      }
    }

    void submitForm() async {
      if (_formKey.currentState!.validate()) {
        widgetNotifier.setLoading(true);
        _formKey.currentState!.save();
        if (authNotifier.userType == UserType.patient) {
          await patientSignUp();
          widgetNotifier.setLoading(false);
        } else if (authNotifier.userType == UserType.nurse) {
          await nurseSignUp();
          widgetNotifier.setLoading(false);
        } else if (authNotifier.userType == UserType.doctor) {
          await doctorSignUp();
          widgetNotifier.setLoading(false);
        }
      }
    }

    void googleSignIn() async {
      if (authNotifier.userType == UserType.patient) {
        bool success = await _patientController.googleSignIn(authNotifier);
        if (success && context.mounted) {
          await LocalStorage.saveUser(authNotifier);
          goToPatientHome();
        }
      } else if (authNotifier.userType == UserType.nurse) {
        bool success = await _nurseController.googleSignIn(authNotifier);
        if (success && context.mounted) {
          await LocalStorage.saveUser(authNotifier);
          goToNurseHome();
        }
      } else if (authNotifier.userType == UserType.doctor) {
        bool success = await _doctorController.googleSignIn(authNotifier);
        if (success && context.mounted) {
          await LocalStorage.saveUser(authNotifier);
          goToDoctorHome();
        }
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
