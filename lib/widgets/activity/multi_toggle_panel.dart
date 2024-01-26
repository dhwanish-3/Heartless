import 'package:flutter/material.dart';
import 'package:heartless/main.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:heartless/widgets/auth/custom_text_button.dart';

class MutltiToggle extends StatelessWidget {
  const MutltiToggle({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);

    return Consumer<WidgetNotifier>(builder: (context, value, child) {
      return Container(
        width: screenWidth * 0.7,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.withOpacity(0.4),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                widgetNotifier.changeToggleSelection(0);
              },
              child: CustomTextButton(
                text: 'ALL',
                containerWidth: screenWidth * 0.2,
                isHighlighted: widgetNotifier.toggleSelectionIndex == 0,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                widgetNotifier.changeToggleSelection(1);
              },
              child: CustomTextButton(
                text: 'MED',
                containerWidth: screenWidth * 0.2,
                isHighlighted: widgetNotifier.toggleSelectionIndex == 1,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                widgetNotifier.changeToggleSelection(2);
              },
              child: CustomTextButton(
                text: 'DIET',
                containerWidth: screenWidth * 0.2,
                isHighlighted: widgetNotifier.toggleSelectionIndex == 2,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                widgetNotifier.changeToggleSelection(3);
              },
              child: CustomTextButton(
                text: 'DRILL',
                containerWidth: screenWidth * 0.2,
                isHighlighted: widgetNotifier.toggleSelectionIndex == 3,
              ),
            ),
          ),
        ]),
      );
    });
  }
}
