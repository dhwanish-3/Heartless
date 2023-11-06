import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heartless/main.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/shared/provider/widget_provider.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool passwordShown;
  final String hintText;
  final String labelText;
  final String startIcon;
  final String? endIcon;
  final String? endIconAlt;
  final TextInputType textInputType;
  const TextFieldInput({
    Key? key,
    required this.textEditingController,
    required this.startIcon,
    this.endIcon,
    this.endIconAlt,
    this.passwordShown = false,
    this.labelText = "",
    required this.hintText,
    this.textInputType = TextInputType.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = 0.9 * screenWidth;
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: containerWidth, // 80% of screen width
      height: 70,
      child: TextField(
        cursorHeight: 19,
        controller: textEditingController,
        keyboardType: TextInputType.name,
        obscureText: passwordShown,
        obscuringCharacter: '•',
        style: const TextStyle(
          fontSize: 15,
          // textBaseline: TextBaseline.alphabetic,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
              color: Constants().customGray, fontSize: 15), // Text color
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 15,
            color: Constants().customGray,
          ),

          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: SvgPicture.asset(
              startIcon,
              height: 20,
            ),
          ),
          suffixIcon: (endIcon != null)
              ? GestureDetector(
                  onTap: () {
                    widgetNotifier
                        .setPasswordShown(!widgetNotifier.passwordShown);
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: SvgPicture.asset(
                      passwordShown ? endIcon! : endIconAlt!,
                      height: 20,
                    ),
                  ),
                )
              : null,

          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),

          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15))),
        ),
      ),
    );
  }
}
