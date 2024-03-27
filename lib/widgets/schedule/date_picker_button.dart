import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';

class DatePickerButton extends StatefulWidget {
  DateTime selectedDate;
  DateTime startDate;
  final ValueChanged<DateTime> onChanged;
  DatePickerButton({
    super.key,
    required this.selectedDate,
    required this.onChanged,
    required this.startDate,
  });

  @override
  State<DatePickerButton> createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<DatePickerButton> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != widget.selectedDate) {
      if (picked.isBefore(widget.startDate)) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Please enter date range'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } else {
        setState(() {
          widget.selectedDate = picked;
          widget.onChanged(widget.selectedDate);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    print(widget.selectedDate.month);
    print(widget.selectedDate.weekday);
    return GestureDetector(
        onTap: () {
          _selectDate(context);
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
                  blurRadius: 0.5,
                  spreadRadius: 0.5,
                  offset: Offset(1, 1),
                ),
              ],
            ),
            width: 200,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    widget.selectedDate.day.toString() +
                        '-' +
                        widget.selectedDate.month.toString() +
                        '-' +
                        widget.selectedDate.year.toString() +
                        ' ' +
                        daysOfWeek[widget.selectedDate.weekday - 1].toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).shadowColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: 20,
                  child: Icon(
                    Icons.calendar_month,
                    color: Theme.of(context).shadowColor,
                    size: 20,
                  ),
                ),
              ],
            )));
  }
}
