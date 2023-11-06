import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heartless/shared/constants.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: screenWidth * 0.7,
        height: 45,
        decoration: BoxDecoration(
          border: Border.all(color: Constants().customGray),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: SvgPicture.asset(
                height: 25,
                'assets/Icons/Google.svg',
              ),
            ),
            const Text(
              'Sign in with Google',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
