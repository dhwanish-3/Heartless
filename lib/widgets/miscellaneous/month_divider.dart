import 'package:flutter/material.dart';

class MonthDivider extends StatelessWidget {
  final String month;
  final String year;
  const MonthDivider({
    super.key,
    required this.month,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        child: Row(children: [
          Expanded(
            flex: 1,
            child: Divider(
              color: Colors.black,
              thickness: 1,
            ),
          ),
          Text(
            '$month $year',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            flex: 1,
            child: Divider(
              color: Colors.black,
              thickness: 1,
            ),
          ),
        ]));
  }
}
