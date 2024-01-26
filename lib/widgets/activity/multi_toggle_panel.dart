import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/widgets/auth/custom_text_button.dart';

class MutltiToggle extends StatelessWidget {
  const MutltiToggle({super.key});

  @override
  Widget build(BuildContext context) {
    bool emailPhoneToggle = true;
    double screenWidth = MediaQuery.of(context).size.width;
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
          child: CustomTextButton(
            text: 'ALL',
            containerWidth: screenWidth * 0.2,
            isHighlighted: emailPhoneToggle,
          ),
        ),
        Expanded(
          flex: 1,
          child: CustomTextButton(
            text: 'MED',
            containerWidth: screenWidth * 0.2,
            isHighlighted: !emailPhoneToggle,
          ),
        ),
        Expanded(
          flex: 1,
          child: CustomTextButton(
            text: 'DIET',
            containerWidth: screenWidth * 0.2,
            isHighlighted: !emailPhoneToggle,
          ),
        ),
        Expanded(
          flex: 1,
          child: CustomTextButton(
            text: 'DRILL',
            containerWidth: screenWidth * 0.2,
            isHighlighted: !emailPhoneToggle,
          ),
        )
      ]),
    );
  }
}
