import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heartless/main.dart';
import 'package:heartless/shared/provider/widget_provider.dart';

class RightButton extends StatelessWidget {
  final String text;
  const RightButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
        height: 40,
        width: screenWidth * 0.25,
        padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).primaryColor),
        child: Consumer<WidgetNotifier>(builder: (context, widgetNotifier, _) {
          if (!widgetNotifier.loading) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      children: [
                        Text(
                          text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            // fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SvgPicture.asset(
                    'assets/Icons/rightNav.svg',
                    height: 20,
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    color: Theme.of(context).canvasColor),
              ),
            );
          }
        }));
  }
}
