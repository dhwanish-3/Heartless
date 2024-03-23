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

  @override
  void dispose() {
    _entryController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  // function called when submitting the form to add new reading/log
  void _submitForm(MedicalReadingType medicalReadingType) async {
    // todo: need for adding some kind of indicator that the form is being submitted
    if (!formKey.currentState!.validate()) {
      return;
    }

    double? value;
    double? optionalValue;
    if (medicalReadingType == MedicalReadingType.bloodPressure) {
      List<String> nums = _entryController.text.split('/');
      if (nums.length != 2) {
        ToastMessage().showError('Enter in the valid format');
        return;
      }
      value = double.tryParse(nums[0]);
      optionalValue = double.tryParse(nums[1]);
      if (value == null || optionalValue == null) {
        ToastMessage().showError('Enter valid numbers');
        return;
      }
    } else {
      value = double.tryParse(_entryController.text);
      if (value == null) {
        ToastMessage().showError('Enter valid value for the reading');
        return;
      }
    }

    // creating a new reading object
    Reading reading = Reading(
      time: DateTime.now(),
      value: value,
      unit: medicalReadingType.unit,
      comment: _commentController.text,
      optionalValue: optionalValue,
      type: medicalReadingType,
      patientId: widget.patient.uid,
    );
    await ReadingController().addReading(reading);
    _entryController.clear();
    _commentController.clear();
    Navigator.of(context).pop();

    // todo: turn off the indicator
  }

  void showFormDialog(
      BuildContext context, MedicalReadingType medicalReadingType) {
    showDialog(
      context: context,
      builder: (context) {
        MedicalReadingType selectedType = MedicalReadingType.waterConsumption;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('New Log Entry'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  medicalReadingType == MedicalReadingType.other
                      ? DropdownButton<MedicalReadingType>(
                          value: selectedType,
                          onChanged: (MedicalReadingType? newValue) {
                            setState(() {
                              selectedType = newValue!;
                              medicalReadingType = newValue;
                            });
                          },
                          items: <MedicalReadingType>[
                            MedicalReadingType.waterConsumption,
                            MedicalReadingType.sleep,
                            MedicalReadingType.distanceWalked,
                            MedicalReadingType.caloriesBurned,
                            MedicalReadingType.steps,
                            MedicalReadingType.exerciseDuration,
                            MedicalReadingType.sodiumIntake,
                            MedicalReadingType.transFatIntake,
                            MedicalReadingType.sugarIntake,
                          ].map<DropdownMenuItem<MedicalReadingType>>(
                              (MedicalReadingType value) {
                            return DropdownMenuItem<MedicalReadingType>(
                                value: value,
                                child: Text(
                                  value.tag,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ));
                          }).toList(),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 5),
                  medicalReadingType == MedicalReadingType.other
                      ? const SizedBox()
                      : TextFormField(
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
                  medicalReadingType == MedicalReadingType.other
                      ? const SizedBox()
                      : TextFormField(
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
                onPressed: () {
                  _submitForm(medicalReadingType);
                },
                child: const Text('Submit'),
              ),
            ],
          );
        });
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
          children: [
            MedicalReadingType.heartRate,
            MedicalReadingType.bloodPressure,
            MedicalReadingType.weight,
            MedicalReadingType.glucose,
            MedicalReadingType.other,
          ].reversed.map((type) {
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
                              time: reading.time,
                              readingType: reading.type,
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
