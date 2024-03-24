import 'package:flutter/material.dart';
import 'package:heartless/services/utils/timeline_service.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/widgets/patient_management/timeline_entry_widget.dart';

class TimelineWidget extends StatelessWidget {
  final String patientId;
  const TimelineWidget({super.key, required this.patientId});

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
                FutureBuilder(
                    future: TimeLineService.getTimeLine(patientId, 3),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return Column(
                          children: snapshot.data!
                              .map((e) => TimeLineEntryidget(
                                  title: e.title, time: e.date))
                              .toList(),
                        );
                      } else {
                        return Text("Failed");
                      }
                    }),
              ],
            )),
        Positioned(
          top: 10,
          right: 30,
          child: IconButton(
            color: Colors.black,
            onPressed: () {
              // todo: navigate to timeline page
            },
            icon: Icon(Icons.keyboard_arrow_right),
          ),
        ),
      ],
    );
  }
}
