import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/widgets/analytics/hero.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SlidingUpPanel(
        minHeight: height * 0.7,
        maxHeight: 800,
        collapsed: Container(
          decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
          ),
        ),
        panel: const Text("this is the panel"),
        body: const HeroWidget(),
        backdropEnabled: true,
        backdropOpacity: 0.1,
      ),
    );
  }
}
