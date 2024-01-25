import 'package:flutter/material.dart';
import 'package:heartless/main.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:heartless/widgets/auth/custom_text_button.dart';

class ToggleButton extends StatelessWidget {
  final bool emailPhoneToggle;
  const ToggleButton({
    super.key,
    required this.emailPhoneToggle,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);
    return Container(
      width: screenWidth * 0.8,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).canvasColor,
        border: Border.all(
          color: Constants.customGray,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: GestureDetector(
          onTap: () {
            widgetNotifier.toggleEmailPhone();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextButton(
                text: 'Email',
                containerWidth: screenWidth * 0.38,
                isHighlighted: emailPhoneToggle,
              ),
              CustomTextButton(
                text: 'Phone',
                containerWidth: screenWidth * 0.38,
                isHighlighted: !emailPhoneToggle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
