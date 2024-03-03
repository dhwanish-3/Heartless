import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';

class Reading extends StatelessWidget {
  final String comment;
  final String reading;
  final String time;

  const Reading(
      {super.key, this.comment = '', this.time = '', required this.reading});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(children: [
      Container(
          width: width * 0.9,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.7)
                : Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 2),
                blurRadius: 2,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    reading,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Constants.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  comment,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).shadowColor,
                  ),
                ),
              ),
            )
          ])),
      Positioned(
        right: 15,
        bottom: 5,
        child: Text(
          time,
          style: const TextStyle(color: Colors.grey, fontSize: 10),
        ),
      ),
    ]);
  }
}
