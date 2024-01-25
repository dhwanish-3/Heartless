import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class OtpWidget extends StatelessWidget {
  final TextEditingController otpController;
  const OtpWidget({
    super.key,
    required this.otpController,
  });

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      autofocus: true,
      controller: otpController,
      hideCharacter: false,
      highlight: true,
      highlightColor: Colors.blue,
      pinBoxColor: Theme.of(context).cardColor,
      defaultBorderColor: Constants.customGray,
      hasTextBorderColor: Theme.of(context).primaryColor,
      pinBoxBorderWidth: 1.0,
      pinBoxRadius: 10.0,
      maxLength: 6,
      hasError: false,
      onTextChanged: (text) {
        //* if anything should be added later on
      },
      wrapAlignment: WrapAlignment.spaceEvenly,
      pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
      pinTextStyle: TextStyle(
        color: Theme.of(context).shadowColor,
        fontWeight: FontWeight.w600,
        fontSize: 25,
      ),
      pinBoxWidth: 50.0,
      pinBoxHeight: 50.0,
    );
  }
}
