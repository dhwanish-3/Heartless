import 'package:flutter/material.dart';
import "package:flutter_svg/svg.dart";
import 'package:heartless/widgets/miscellaneous/right_trailing_button.dart';
import 'package:heartless/widgets/auth/user_type.dart';

class ChooseUserPage extends StatelessWidget {
  const ChooseUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    void goToLoginOrSignupPage() {
      Navigator.pushNamed(context, '/loginOrSignup'); // todo : add correct name
    }

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        // fit: StackFit.loose,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SvgPicture.asset(
              'assets/illustrations/cool_design.svg',
              height: height * 0.25,
            ),
          ),
          Positioned(
              top: height * 0.15,
              left: 50,
              child: const Text(
                'Specify Your Role',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              )),
          Positioned(
            top: height * 0.25,
            child: const UserTypeWidget(),
          ),
          Positioned(
            bottom: 80,
            right: 60,
            child: GestureDetector(
                onTap: goToLoginOrSignupPage,
                child: const RightButton(text: 'Next')),
          )
        ],
      ),
    );
  }
}
