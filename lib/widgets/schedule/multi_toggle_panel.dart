import 'package:flutter/material.dart';
import 'package:heartless/services/enums/schedule_toggle_type.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:heartless/widgets/auth/custom_text_button.dart';
import 'package:provider/provider.dart';

class MutltiToggle extends StatelessWidget {
  final bool isTimeLine;
  const MutltiToggle({
    super.key,
    this.isTimeLine = false,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);

    return Consumer<WidgetNotifier>(builder: (context, value, child) {
      final buttons = ScheduleToggleType.values.map((text) {
        return Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              widgetNotifier.changeToggleSelection(text);
            },
            child: CustomTextButton(
              text: isTimeLine ? text.alternateTimeLineTypeString : text.title,
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
                  -1 + widgetNotifier.scheduleToggleType.index * 0.6667, 0),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: SizedBox(
                height: 30,
                child: FractionallySizedBox(
                  widthFactor: 0.25,
                  child: CustomTextButton(
                    text: isTimeLine
                        ? widgetNotifier
                            .scheduleToggleType.alternateTimeLineTypeString
                        : widgetNotifier.scheduleToggleType.title,
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
