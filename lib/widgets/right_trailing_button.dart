import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RightButton extends StatelessWidget {
  final String text;
  const RightButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 40,
      width: screenWidth * 0.25,
      padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            text,
            style: const TextStyle(
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
