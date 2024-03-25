import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:heartless/widgets/auth/custom_text_button.dart';
import 'package:provider/provider.dart';

// ! This widget is not beign used anywhere
class TwoButtonToggle extends StatelessWidget {
  final bool emailPhoneToggle;
  final String leftButtonText;
  final String rightButtonText;
  const TwoButtonToggle({
    super.key,
    required this.emailPhoneToggle,
    this.leftButtonText = 'Email',
    this.rightButtonText = 'Phone',
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);

    return Consumer<WidgetNotifier>(builder: (context, value, child) {
      return Container(
        width: screenWidth * 0.8,
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).canvasColor,
          border: Border.all(
            color: Constants.customGray,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: GestureDetector(
            onTap: () {
              widgetNotifier.toggleEmailPhone();
            },
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          widgetNotifier.toggleEmailPhone();
                        },
                        child: CustomTextButton(
                          height: 40,
                          text: leftButtonText,
                          containerWidth: screenWidth * 0.38,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          widgetNotifier.toggleEmailPhone();
                        },
                        child: CustomTextButton(
                          height: 40,
                          text: rightButtonText,
                          containerWidth: screenWidth * 0.38,
                        ),
                      ),
                    ),
                  ],
                ),
                AnimatedAlign(
                  alignment: widgetNotifier.emailPhoneToggle
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: SizedBox(
                    height: 40,
                    child: FractionallySizedBox(
                      widthFactor: 0.5,
                      child: CustomTextButton(
                        text: widgetNotifier.emailPhoneToggle
                            ? leftButtonText
                            : rightButtonText,
                        containerWidth: screenWidth * 0.38,
                        isHighlighted: true,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
