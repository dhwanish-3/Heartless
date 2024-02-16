import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';

class TimePickerButton extends StatefulWidget {
  const TimePickerButton({super.key});

  @override
  _TimePickerButtonState createState() => _TimePickerButtonState();
}

class _TimePickerButtonState extends State<TimePickerButton> {
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 100,
        height: 60,
        decoration: BoxDecoration(
          color: Constants.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: Text('Select Time',
                style: TextStyle(
                  color: Theme.of(context).cardColor,
                  fontSize: 16,
                ))),
      ),
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: selectedTime,
        );
        if (picked != null && picked != selectedTime) {
          setState(() {
            selectedTime = picked;
          });
        }
      },
    );
  }
}
