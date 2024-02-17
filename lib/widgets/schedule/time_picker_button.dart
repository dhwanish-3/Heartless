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
            padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
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
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            width: 150,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    widget.selectedTime.hour.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).shadowColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    ':',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).shadowColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    widget.selectedTime.minute.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).shadowColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    widget.selectedTime.period == DayPeriod.am ? 'AM' : 'PM',
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).shadowColor,
                    ),
                  ),
                ),
                // Expanded(flex: 2, child: Image.asset('assets/Icons/clock.png'))
              ],
            )));
  }
}
