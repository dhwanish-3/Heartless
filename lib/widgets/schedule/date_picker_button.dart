import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';

class DatePickerButton extends StatefulWidget {
  DateTime selectedDate;
  final ValueChanged<DateTime> onChanged;
  DatePickerButton({
    super.key,
    required this.selectedDate,
    required this.onChanged,
  });

  @override
  State<DatePickerButton> createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<DatePickerButton> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != widget.selectedDate) {
      if (picked.isBefore(DateTime.now())) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Please enter a date that is not in the past.'),
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
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            width: 220,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    widget.selectedDate.day.toString(),
                    textAlign: TextAlign.center,
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
                    '-',
                    textAlign: TextAlign.center,
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
                    widget.selectedDate.month.toString(),
                    textAlign: TextAlign.center,
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
                    // widget.selectedTime.period == DayPeriod.am ? 'AM' : 'PM',
                    '-',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).shadowColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    textAlign: TextAlign.center,
                    widget.selectedDate.year.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).shadowColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    textAlign: TextAlign.center,
                    daysOfWeek[widget.selectedDate.weekday - 1].toString(),
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).shadowColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Image.asset('assets/Icons/calendar.png'),
                ),
              ],
            )));
  }
}
