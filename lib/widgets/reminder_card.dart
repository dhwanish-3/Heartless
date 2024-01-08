import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';

//* type :- medicine 0 : food 1 : exercise 2
//* status :- active 0: done 1: missed 2

class Reminder extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final int type;
  final int status;
  const Reminder(
      {super.key,
      required this.title,
      required this.description,
      required this.time,
      required this.type,
      this.status = 0});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = 0.9 * screenWidth;
    String buttonUrl = (status == 0)
        ? 'assets/Icons/bell.png'
        : (status == 1)
            ? 'assets/Icons/tick2.png'
            : 'assets/Icons/wrong.png';
    String trailLabel = (status == 0) ? 'Swipe right to mark as done >>' : '';
    String imageUrl = (type == 0)
        ? 'assets/Icons/med2.png'
        : type == 1
            ? 'assets/Icons/food2.png'
            : type == 2
                ? 'assets/Icons/exercise.png'
                : 'assets/Icons/exercise.png';
    Color bgColor = type == 0
        ? Constants.medColor
        : type == 1
            ? Constants.foodColor
            : type == 2
                ? Constants.exerciseColor
                : Constants.exerciseColor;
    return Container(
      height: 85,
      width: containerWidth,
      decoration: BoxDecoration(
        // color: Theme.of(context).canvasColor,
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
              width: 60,
              height: 60,
              margin: const EdgeInsets.all(12),
              // padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Image.asset(
                imageUrl,
                fit: BoxFit.contain,
              )),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      // padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                      height: 50,
                      width: containerWidth - 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              title,
                              textAlign: TextAlign.left,
                              // style: Theme.of(context).textTheme.bodyLarge,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(description,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                )),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        width: 33,
                        height: 33,
                        margin: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                        // padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Constants.notifColor,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(17)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 2,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Image.asset(buttonUrl))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        time,
                        // style: Theme.of(context).textTheme.headlineSmall,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        trailLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
