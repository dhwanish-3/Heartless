/*

different types are 
perhaps could later on associate number to each type

medicine
exercise
food
bp
heartRate
weight
glucose
*/

import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';

class HeroWidget extends StatelessWidget {
  final String type;
  const HeroWidget({super.key, this.type = "glucose"});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String imageUrl = type == "medicine"
        ? "assets/Icons/med2.png"
        : type == "exercise"
            ? "assets/Icons/Hero/exerciseHero.png"
            : type == "food"
                ? "assets/Icons/food.png"
                : type == "bp"
                    //* must find an image for blood pressure currently using the same one for heart rate
                    ? "assets/Icons/Hero/heartRate.png"
                    : type == "heartRate"
                        ? "assets/Icons/Hero/heartRate.png"
                        : type == "weight"
                            ? "assets/Icons/Hero/weight.png"
                            : type == "glucose"
                                ? "assets/Icons/Hero/glucose.png"
                                : "assets/Icons/med2.png";
    String title = type == "medicine"
        ? "MEDICINE           "
        : type == "exercise"
            ? "EXERCISE           "
            : type == "food"
                ? "NUTRITION         "
                : type == "bp"
                    ? "BLOOD PRESSURE"
                    : type == "heartRate"
                        ? "HEART RATE       "
                        : type == "weight"
                            ? "BODY WEIGHT       "
                            : type == "glucose"
                                ? "BLOOD SUGAR      "
                                : "MEDICINE           ";
    return Container(
      color: Constants.primaryColor,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              alignment: Alignment.bottomCenter,
              height: height * 0.15,
              width: width * 0.5,
              decoration: BoxDecoration(
                // color: Colors.white,
                image: DecorationImage(
                  // alignment: Alignment.bottomCenter,
                  image: AssetImage(imageUrl),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.05,
              // color: Colors.red,
              width: width * 0.8,
              // padding: const EdgeInsets.all(1),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  title,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 36,
                    // overflow: TextOverflow.clip,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w600,

                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ]),
    );
  }
}
