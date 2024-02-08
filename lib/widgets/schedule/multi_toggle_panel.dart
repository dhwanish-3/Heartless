import 'package:flutter/material.dart';
import 'package:heartless/main.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:heartless/widgets/auth/custom_text_button.dart';

enum ButtonText { ALL, MED, DIET, DRILL }

class MutltiToggle extends StatelessWidget {
  const MutltiToggle({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);

    return Consumer<WidgetNotifier>(builder: (context, value, child) {
      final buttons = ButtonText.values.map((text) {
        return Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              widgetNotifier.changeToggleSelection(text.index);
            },
            child: CustomTextButton(
              text: text.toString().split('.').last,
              containerWidth: screenWidth * 0.2,
              isHighlighted: false,
            ),
          ),
        );
      }).toList();
      return Container(
        width: screenWidth * 0.7,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.withOpacity(0.4),
        ),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: buttons,
            ),
            AnimatedAlign(
              alignment: Alignment(
                  -1 + widgetNotifier.toggleSelectionIndex * 0.6667, 0),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: SizedBox(
                height: 30,
                child: FractionallySizedBox(
                  widthFactor: 0.25,
                  child: CustomTextButton(
                    text: ButtonText.values[widgetNotifier.toggleSelectionIndex]
                        .toString()
                        .split('.')
                        .last,
                    containerWidth: screenWidth * 0.2,
                    isHighlighted: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
