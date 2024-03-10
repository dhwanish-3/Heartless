import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthYearSelector extends StatefulWidget {
  final Function(String month, int year) onMonthYearChanged;
  const MonthYearSelector({
    super.key,
    required this.onMonthYearChanged,
  });

  @override
  State<MonthYearSelector> createState() => _MonthYearSelectorState();
}

class _MonthYearSelectorState extends State<MonthYearSelector> {
  final List<String> allMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  final List<int> years =
      List<int>.generate(6, (i) => DateTime.now().year - 5 + i);
  String selectedMonth = DateFormat('MMMM').format(DateTime.now());
  int selectedYear = DateTime.now().year;
  @override
  Widget build(BuildContext context) {
    List<String> months = allMonths;
    if (selectedYear == DateTime.now().year) {
      months = allMonths.sublist(0, DateTime.now().month);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<String>(
          value: selectedMonth,
          onChanged: (newMonth) {
            // todo: make use of widgetNotifier
            setState(() {
              selectedMonth = newMonth!;
              widget.onMonthYearChanged(selectedMonth, selectedYear);
            });
          },
          items: months.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                ));
          }).toList(),
        ),
        const Text(' '),
        DropdownButton<int>(
          value: selectedYear,
          onChanged: (newYear) {
            setState(() {
              selectedYear = newYear!;
              widget.onMonthYearChanged(selectedMonth, selectedYear);

              if (newYear == DateTime.now().year) {
                selectedMonth = allMonths[0];
              }
            });
          },
          items: years.map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(value.toString()),
            );
          }).toList(),
        ),
      ],
    );
  }
}
