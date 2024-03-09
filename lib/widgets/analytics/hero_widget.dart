import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';

//custom function for finding font size
double calculateFontSize(String text, double maxWidth) {
  double fontSize = 24.0; // Start with a high value

  while (fontSize > 1.0) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          letterSpacing: 3,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    if (textPainter.width <= maxWidth) {
      return fontSize;
    }
    fontSize--;
  }
  debugPrint(fontSize.toString());
  return fontSize;
}

class HeroWidget extends StatelessWidget {
  final String title;
  final String imageUrl;

  const HeroWidget({
    super.key,
    this.title = "MEDICINE",
    this.imageUrl = "assets/Icons/med2.png",
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double fontSize = calculateFontSize(title, width * 0.6);
    debugPrint(fontSize.toString());

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
                  // fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.05,
              // color: Colors.red,
              width: width * 0.8,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        // overflow: TextOverflow.clip,
                        height: 1,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w500,

                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}
