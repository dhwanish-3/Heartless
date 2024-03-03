import 'package:calendar_slider/calendar_slider.dart';
import 'package:flutter/material.dart';
import 'package:heartless/main.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:heartless/widgets/reading.dart';

List<Map<String, String>> readings = [
  {
    'reading': '100 bpm',
    'comment': 'This is a comment',
    'time': '12:00 AM',
  },
  {
    'reading': '72 bpm',
    'comment': '',
    'time': '9:00 PM',
  },
  {
    'reading': '68 bpm',
    'comment': 'This is a comment',
    'time': '7:00 PM',
  },
  {
    'reading': '81 bpm',
    'comment':
        'This is a long comment that should be going beyond one line and I wanted to test whether the widget is capable of handling overflow cases',
    'time': '12:00 PM',
  },
];

class DayWiseLog extends StatelessWidget {
  final String unit; //mg/dL for glucose, kg for weight, bpm for heart rate
  final String label1;
  final String hintText1;
// for blood pressure two entries are needed, systolic and diastolic
  final int readingCount;
  final String label2;
  final String hintText2;
  const DayWiseLog({
    super.key,
    required this.unit,
    this.readingCount = 1,
    this.label1 = 'Reading',
    this.label2 = '',
    this.hintText1 = '72',
    this.hintText2 = '72',
  });

  void showFormDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final entryController = TextEditingController();
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Log Entry'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: entryController,
                  decoration: InputDecoration(
                    labelText: '$label1 ($unit)',
                    hintText: hintText1,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an entry';
                    }
                    return null;
                  },
                ),
                if (readingCount > 1)
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: '$label2 ($unit)',
                      hintText: hintText2,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an entry';
                      }
                      return null;
                    },
                  ),
                TextFormField(
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall, //!should see how it looks in actual mobile
                  controller: commentController,
                  decoration: const InputDecoration(
                    labelText: 'Comment',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                print(entryController.text);
                print(commentController.text);
                // if (formKey.currentState.validate()) {
                //   // Process data.
                //   Navigator.of(context).pop();
                // }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetNotifier widgetNotifier = Provider.of<WidgetNotifier>(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showFormDialog(context);
          },
          backgroundColor: Constants.primaryColor,
          child: const Icon(Icons.add),
        ),
        appBar: CalendarSlider(
          // controller: calendarSliderController,
          selectedDayPosition: SelectedDayPosition.center,
          fullCalendarWeekDay: WeekDay.short,
          selectedTileBackgroundColor: Constants.primaryColor,
          monthYearButtonBackgroundColor: Constants.cardColor,
          monthYearTextColor: Colors.black,
          tileBackgroundColor: Theme.of(context).cardColor,
          selectedDateColor: Colors.white,
          dateColor: Theme.of(context).shadowColor,
          locale: 'en',
          initialDate: DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 180)),
          lastDate: DateTime.now().add(const Duration(days: 100)),
          onDateSelected: (date) {
            widgetNotifier.setSelectedDate(date);
          },
        ),
        body: SafeArea(
            child: ListView.builder(
          itemCount: readings.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  child: Reading(
                    reading: readings[index]['reading'] as String,
                    comment: readings[index]['comment'] as String,
                    time: readings[index]['time'] as String,
                  ),
                ),
              ],
            );
          },
        )));
  }
}
