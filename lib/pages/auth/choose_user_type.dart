import 'package:flutter/material.dart';
import "package:flutter_svg/svg.dart";
import 'package:heartless/main.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:heartless/widgets/right_trailing_button.dart';
import 'package:heartless/widgets/user_type.dart';

class ChooseUserPage extends StatelessWidget {
  const ChooseUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        // fit: StackFit.loose,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SvgPicture.asset(
              'assets/illustrations/LftBtmDsgnElmt.svg',
              height: height * 0.25,
            ),
          ),
          Positioned(
              top: height * 0.15,
              left: 50,
              child: const Text(
                'Specify Your Role',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              )),
          Positioned(
            top: height * 0.25,
            child: UserTypeWidget(
              userType: widgetNotifier.userType,
            ),
          ),
          Positioned(
            bottom: 80,
            right: 60,
            child: GestureDetector(
                onTap: () {
                  // todo
                },
                child: const RightButton(text: 'Next')),
          )
        ],
      ),
    );
  }
}
