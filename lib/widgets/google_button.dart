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
    return Container(
      width: screenWidth * 0.7,
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(color: Constants.customGray),
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardColor,
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
          Text(
            'Sign in with Google',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).shadowColor),
          )
        ],
      ),
    );
  }
}
