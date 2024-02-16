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
  final int maxLines;
  const TextFieldInput({
    Key? key,
    required this.textEditingController,
    this.startIcon = '',
    this.endIcon,
    this.endIconAlt,
    this.passwordShown = false,
    this.labelText = "",
    required this.hintText,
    this.maxLines = 1,
    this.textInputType = TextInputType.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = 0.9 * screenWidth;
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(6.0),
      width: containerWidth, // 90% of screen width
      // !  when height is specified, widget shrinks on validator error
      // height: 65,
      child: TextFormField(
        cursorHeight: 19,
        controller: textEditingController,
        keyboardType: textInputType,
        obscureText: passwordShown,
        maxLines: maxLines,
        obscuringCharacter: '•',
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).cardColor,
          floatingLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Constants.primaryColor,
          ),
          labelText: labelText,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
          // labelStyle: Theme.of(context).textTheme.headlineSmall,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.labelMedium,
          prefixIcon: startIcon == ''
              ? null
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: SvgPicture.asset(
                    startIcon,
                    height: 23,
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
                      height: 23,
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            if (textInputType == TextInputType.emailAddress) {
              return 'Please enter an email';
            } else if (textInputType == TextInputType.visiblePassword) {
              return 'Please enter a password';
            } else {
              return 'Please enter a value';
            }
          } else if (textInputType == TextInputType.visiblePassword &&
              value.length < 6) {
            return 'Please enter a password with atleast 6 characters';
          }
          return null;
        },
      ),
    );
  }
}
