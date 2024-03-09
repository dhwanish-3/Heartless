import 'package:flutter/material.dart';
import 'package:heartless/widgets/analytics/graphs_widget.dart';
import 'package:heartless/widgets/analytics/hero_widget.dart';
import 'package:heartless/widgets/analytics/panel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AnalyticsPage extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String patientId;
  const AnalyticsPage({
    super.key,
    this.title = "EXERCISE",
    this.imageUrl = "assets/Icons/Hero/exerciseHero.png",
    required this.patientId,
  });

  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  //! collapsed widget is rendered over panel widget. Should somehow use the controller to display the panel only when it is expanded
  final PanelController _panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SlidingUpPanel(
            controller: _panelController,
            parallaxEnabled: true,
            minHeight: height * 0.75,
            maxHeight: height,
            onPanelSlide: (position) {
              setState(() {}); // Call setState to rebuild the widget
            },
            collapsed: Material(
              elevation: 0, // This adds the shadow
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: SizedBox(
                height: height * 0.75, // Set a fixed height for the container
                child: Column(
                  children: [
                    Divider(
                      height: 20,
                      thickness: 2,
                      indent: MediaQuery.of(context).size.width / 2 - 20,
                      endIndent: MediaQuery.of(context).size.width / 2 - 20,
                    ),
                    Expanded(
                      child: Scaffold(
                        body: FittedBox(
                          fit: BoxFit.fill,
                          child: GraphsWidget(
                            patientId: widget.patientId,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            panel: PanelWidget(
              title: widget.title,
              patientId: widget.patientId,
            ),
            // If the panel is closed, render an empty widget
            // body: Container(),
            body: HeroWidget(
              title: widget.title,
              imageUrl: widget.imageUrl,
            ),
            backdropEnabled: true,
            backdropOpacity: 0.1,
          );
        },
      ),
    );
  }
}
