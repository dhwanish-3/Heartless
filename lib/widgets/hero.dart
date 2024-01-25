import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';

class HeroWidget extends StatelessWidget {
  const HeroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: Constants.primaryColor,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              alignment: Alignment.bottomCenter,
              height: height * 0.2,
              width: width * 0.6,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  // alignment: Alignment.bottomCenter,
                  image: AssetImage("assets/Icons/med2.png"),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.05,
              // color: Colors.red,
              width: width * 0.8,
              // padding: const EdgeInsets.all(1),
              child: const Flexible(
                child: Text(
                  'NUTRITION',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 38,
                    overflow: TextOverflow.clip,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ]),
    );
  }
}
