import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heartless/shared/constants.dart';

class RightButton extends StatelessWidget {
  const RightButton({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 40,
      width: screenWidth * 0.25,
      padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
      decoration: BoxDecoration(
          // border: Border.all(
          //   color: Constants().customGray,
          // ),
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SvgPicture.asset(
            'assets/Icons/rightNav.svg',
            height: 20,
          ),
        ],
      ),
    );
  }
}
