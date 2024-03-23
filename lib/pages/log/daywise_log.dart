import 'package:calendar_slider/calendar_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:heartless/backend/controllers/reading_controller.dart';
import 'package:heartless/services/enums/medical_reading_type.dart';
import 'package:heartless/services/utils/toast_message.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/models/reading.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:heartless/widgets/log/reading_tile.dart';
import 'package:provider/provider.dart';

class DayWiseLogPage extends StatefulWidget {
  final AppUser patient;
  // final MedicalReadingType medicalReadingType;

  const DayWiseLogPage({
    super.key,
    required this.patient,
  });

  @override
  State<DayWiseLogPage> createState() => _DayWiseLogState();
}

class _DayWiseLogState extends State<DayWiseLogPage> {
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
    double? value = double.tryParse(_entryController.text);
    if (value == null) {
      ToastMessage().showError('Enter valid value for the reading');
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
      value: double.parse(_entryController.text),
      unit: MedicalReadingType.heartRate.unit,
      comment: _commentController.text,
      type: ReadingType.heartRate,
      patientId: widget.patient.uid,
    );
    await ReadingController().addReading(reading);
    clicked = false;
    // todo: turn off the indicator
  }

  void showFormDialog(
      BuildContext context, MedicalReadingType medicalReadingType) {
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
                    labelText:
                        '${medicalReadingType.tag} (${medicalReadingType.unit})',
                    hintText: medicalReadingType.hintText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an entry';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  maxLines: 2,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall, //! should see how it looks in actual mobile
                  controller: _commentController,
                  decoration: InputDecoration(
                    labelText: 'Comment',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);

    //* setting the selected date to today without notifying the listeners (if notified, it will rebuild the whole widget tree & lead to error, which is not needed here)
    widgetNotifier.setSelectedDateWithoutNotifying(DateTime.now());

    return Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     showFormDialog(context);
        //   },
        //   backgroundColor: Constants.primaryColor,
        //   child: const Icon(Icons.add),
        // ),

        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: const IconThemeData(size: 22.0),
          backgroundColor: Constants.primaryColor,
          children: MedicalReadingType.values.reversed.map((type) {
            return SpeedDialChild(
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      type.icon,
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // backgroundColor: Constants.primaryColor,
              label: type.tag,
              labelStyle: const TextStyle(fontSize: 16.0),
              onTap: () {
                showFormDialog(context, type);
              },
            );
          }).toList(),
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
            Consumer<WidgetNotifier>(builder: (context, widgetNotifier, child) {
              return StreamBuilder(
                  stream: ReadingController.getAllReadingsOfTheDate(
                      widgetNotifier.selectedDate, widget.patient.uid),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Reading reading = Reading.fromMap(
                                snapshot.data.docs[index].data());
                            return GenericReadingTile(
                              reading: reading.value.toString(),
                              comment: reading.comment ?? "",
                              time: reading.time.toString(),
                              readingType: MedicalReadingType.heartRate,
                            );
                          });
                    } else {
                      return const Text("No reading available");
                    }
                  });
            })
          ],
        ));
  }
}
