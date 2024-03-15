import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/widgets/patient_management/timeline_entry_widget.dart';

class TimelineWidget extends StatelessWidget {
  const TimelineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            // height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.cardColor
                  : Constants.darkCardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Timeline',
                      textAlign: TextAlign.start,
                      // style: Theme.of(context).textTheme.headlineMedium
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).shadowColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TimeLineEntryidget(title: 'Blood Report', time: DateTime.now()),
                TimeLineEntryidget(title: 'Glucose Test', time: DateTime.now()),
              ],
            )),
        Positioned(
          top: 10,
          right: 30,
          child: IconButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.keyboard_arrow_right),
          ),
        ),
      ],
    );
  }
}
