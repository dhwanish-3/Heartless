import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/widgets/analytics/hero.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AnalyticsPage extends StatelessWidget {
  final String type;
  const AnalyticsPage({super.key, this.type = "med"});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String title = type == "med"
        ? "MEDICINE"
        : type == "exercise"
            ? "EXERCISE"
            : type == "food"
                ? "NUTRITION"
                : "MEDICINE";
    return Scaffold(
      body: SlidingUpPanel(
        minHeight: height * 0.75,
        maxHeight: height,
        collapsed: Container(
          decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
          ),
        ),
        panel: Scaffold(
          appBar: AppBar(
            backgroundColor: Constants.primaryColor,
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            centerTitle: true,
          ),
        ),
        body: const HeroWidget(),
        backdropEnabled: true,
        backdropOpacity: 0.1,
      ),
    );
  }
}
