import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heartless/shared/constants.dart';

class LeftButton extends StatelessWidget {
  const LeftButton({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 40,
      width: screenWidth * 0.25,
      padding: const EdgeInsets.fromLTRB(10, 5, 20, 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgPicture.asset(
            'assets/Icons/leftNav.svg',
            height: 20,
          ),
          const Text(
            'Back',
            style: TextStyle(
              color: Constants.customGray,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
