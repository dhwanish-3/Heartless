import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heartless/shared/constants.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
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
    this.isPass = false,
    this.labelText = "",
    required this.hintText,
    this.textInputType = TextInputType.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = 0.8 * screenWidth;
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: containerWidth, // 80% of screen width
      height: 70,
      child: TextField(
        cursorHeight: 15,
        controller: textEditingController,
        keyboardType: TextInputType.name,
        obscureText: isPass,
        obscuringCharacter: '*',
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
              color: Constants().customGray, fontSize: 15), // Text color
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 15,
            color: Constants().customGray,
            // color: Theme.of(context).primaryColor,
          ),
          // fillColor: const Color.fromARGB(15, 211, 214, 214),
          // filled: true,

          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: SvgPicture.asset(
              startIcon,
              height: 20,
            ),
          ),
          suffixIcon: (endIcon != null)
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: SvgPicture.asset(
                    endIcon!,
                    height: 20,
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
