import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';

class TimePickerButton extends StatefulWidget {
  TimeOfDay selectedTime;
  final ValueChanged<TimeOfDay> onTimeChanged;
  TimePickerButton({
    super.key,
    required this.selectedTime,
    required this.onTimeChanged,
  });

  @override
  _TimePickerButtonState createState() => _TimePickerButtonState();
}

class _TimePickerButtonState extends State<TimePickerButton> {
  // TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    String timeString = (widget.selectedTime.hour > 12
                ? widget.selectedTime.hour - 12
                : widget.selectedTime.hour)
            .toString() +
        ' : ' +
        (widget.selectedTime.minute < 10
            ? '0' + widget.selectedTime.minute.toString()
            : widget.selectedTime.minute.toString()) +
        ' ' +
        (widget.selectedTime.period == DayPeriod.am ? ' AM' : ' PM');
    return GestureDetector(
        onTap: () async {
          final TimeOfDay? picked = await showTimePicker(
            context: context,
            initialTime: widget.selectedTime,
          );
          if (picked != null && picked != widget.selectedTime) {
            widget.onTimeChanged(picked);
          }
        },
        child: Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).cardColor,
              border: Border.all(
                color: Theme.of(context).shadowColor,
                width: 0.6,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Constants.customGray,
                  // color: Theme.of(context).shadowColor.withOpacity(0.5),
                  blurRadius: 0.5,
                  spreadRadius: 0.5,
                  offset: Offset(1, 1),
                ),
              ],
            ),
            // width: 150,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeString,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).shadowColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )));
  }
}
