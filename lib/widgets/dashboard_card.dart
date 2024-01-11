import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';

class Dash_Card extends StatelessWidget {
  const Dash_Card({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double width = 0.35 * screenWidth;
    return Container(
        height: width,
        width: width,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
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
        child: Container(
          // padding: EdgeInsets.all(10),
          margin: const EdgeInsets.fromLTRB(10, 15, 5, 0),
          child: const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              'Nutrition',
              style: TextStyle(
                color: Constants.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ));
  }
}
