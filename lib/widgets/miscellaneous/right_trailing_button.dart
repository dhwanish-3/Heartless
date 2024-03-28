import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:provider/provider.dart';

class RightButton extends StatelessWidget {
  final String text;
  final String imageUrl;
  final bool showTrailingIcon;
  const RightButton({
    super.key,
    required this.text,
    this.imageUrl = 'assets/Icons/rightNav.svg',
    this.showTrailingIcon = true,
  });

  @override
  Widget build(BuildContext context) {
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
                showTrailingIcon
                    ? Expanded(
                        flex: 1,
                        child: SvgPicture.asset(
                          imageUrl,
                          height: 20,
                        ),
                      )
                    : const SizedBox(),
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
