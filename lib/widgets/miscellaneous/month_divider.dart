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
    return Column(
      children: [
        SizedBox(height: 16),
        Container(
            height: 30,
            child: Row(children: [
              SizedBox(width: 30),
              Expanded(
                flex: 1,
                child: Divider(
                  thickness: 1,
                ),
              ),
              SizedBox(width: 10),
              Text(
                '$month $year',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: Divider(
                  thickness: 1,
                ),
              ),
              SizedBox(width: 30),
            ])),
      ],
    );
  }
}
