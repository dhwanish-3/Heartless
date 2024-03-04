import 'package:calendar_slider/calendar_slider.dart';
import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/reading_controller.dart';
import 'package:heartless/main.dart';
import 'package:heartless/services/utils/toast_message.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/models/reading.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:heartless/widgets/reading_tile.dart';

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
  final AppUser patient;
  final String unit; //mg/dL for glucose, kg for weight, bpm for heart rate
  final String label1;
  final String hintText1;
// for blood pressure two entries are needed, systolic and diastolic
  final int readingCount;
  final String label2;
  final String hintText2;

  DayWiseLog({
    super.key,
    required this.patient,
    required this.unit,
    this.readingCount = 1,
    this.label1 = 'Reading',
    this.label2 = '',
    this.hintText1 = '72',
    this.hintText2 = '72',
  });

  final formKey = GlobalKey<FormState>();
  final TextEditingController _entryController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  bool clicked = false;

  // function called when submitting the form to add new reading/log
  void _submitForm() async {
    // todo: need for adding some kind of indicator that the form is being submitted
    if (!formKey.currentState!.validate()) {
      return;
    }
    // handling multiple clicks
    if (clicked) {
      ToastMessage().showError('Please wait for the previous task to complete');
      return;
    }
    clicked = true;
    // creating a new reading object
    Reading reading = Reading(
      time: DateTime.now(),
      value: _entryController.text,
      unit: unit,
      comments: _commentController.text,
      type: ReadingType.heartRate,
      patientId: patient.uid,
    );
    await ReadingController().addReading(reading);
    clicked = false;
    // todo: turn off the indicator
  }

  void showFormDialog(BuildContext context) {
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
                  controller: _entryController,
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
                  controller: _commentController,
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
              onPressed: _submitForm,
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetNotifier widgetNotifier = Provider.of<WidgetNotifier>(context);
    widgetNotifier.setSelectedDate(DateTime.now());
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
        body: Column(
          children: [
            StreamBuilder(
                stream: ReadingController.getAllReadingsOfTheDate(
                    widgetNotifier.selectedDate, patient.uid),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          Reading reading =
                              Reading.fromMap(snapshot.data.docs[index].data());
                          return ReadingTile(
                            reading: reading.value,
                            comment: reading.comments,
                            time: reading.time.toString(),
                          );
                        });
                  } else {
                    return const Text("No reading available");
                  }
                })
          ],
        ));
  }
}
