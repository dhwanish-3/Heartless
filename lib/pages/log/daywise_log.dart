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
import 'package:heartless/widgets/log/add_button.dart';
import 'package:heartless/widgets/log/diary_list.dart';
import 'package:heartless/widgets/log/hero_dialog.dart';
import 'package:heartless/widgets/log/reading_tile.dart';
import 'package:provider/provider.dart';

class DayWiseLogPage extends StatefulWidget {
  final AppUser patient;

  const DayWiseLogPage({
    super.key,
    required this.patient,
  });

  @override
  State<DayWiseLogPage> createState() => _DayWiseLogState();
}

class _DayWiseLogState extends State<DayWiseLogPage> {
  final formKey = GlobalKey<FormState>();
  final secondaryFormKey = GlobalKey<FormState>();

  final TextEditingController _entryController = TextEditingController();

  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _entryController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  // function called when submitting the form to add new reading/log
  void _submitForm(MedicalReadingType medicalReadingType,
      [bool secondaryMetric = false]) async {
    // todo: need for adding some kind of indicator that the form is being submitted

    if (!secondaryMetric) {
      if (!formKey.currentState!.validate()) {
        return;
      }
    } else {
      if (!secondaryFormKey.currentState!.validate()) {
        return;
      }
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

  void showFormDialogWithPopup(
      BuildContext context, MedicalReadingType medicalReadingType) {
    showDialog(
      context: context,
      builder: (context) {
        MedicalReadingType selectedType = MedicalReadingType.waterConsumption;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('Choose from the list of metrics'),
            content: Form(
              key: secondaryFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButton<MedicalReadingType>(
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
                  ),
                  const SizedBox(height: 5),
                  buildPopUpTextFormFields(
                    entryController: _entryController,
                    commentController: _commentController,
                    medicalReadingType: medicalReadingType,
                    context: context,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  _entryController.clear();
                  _commentController.clear();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                onPressed: () {
                  _submitForm(medicalReadingType, true);
                },
                child: const Text('Submit'),
              ),
            ],
          );
        });
      },
    );
  }

  void showFormDialog(
      BuildContext context, MedicalReadingType medicalReadingType) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('New Log Entry'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buildPopUpTextFormFields(
                    entryController: _entryController,
                    commentController: _commentController,
                    medicalReadingType: medicalReadingType,
                    context: context,
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
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: const IconThemeData(size: 22.0),
          backgroundColor: Theme.of(context).primaryColor,
          children: [
            MedicalReadingType.diary,
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
              onTap: () async {
                if (type == MedicalReadingType.diary) {
                  await Navigator.of(context)
                      .push(HeroDialogRoute(builder: (context) {
                    return AddDiaryPopUpCard(
                      patient: widget.patient,
                    );
                  }));
                } else if (type == MedicalReadingType.other) {
                  showFormDialogWithPopup(
                      context, MedicalReadingType.waterConsumption);
                } else {
                  showFormDialog(context, type);
                }
              },
            );
          }).toList(),
        ),
        appBar: CalendarSlider(
          // controller: calendarSliderController,
          selectedDayPosition: SelectedDayPosition.center,
          fullCalendarWeekDay: WeekDay.short,
          selectedTileBackgroundColor: Theme.of(context).primaryColor,
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<WidgetNotifier>(
                  builder: (context, widgetNotifier, child) {
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
                                optionalValue: reading.optionalValue.toString(),
                                comment: reading.comment ?? "",
                                time: reading.time,
                                readingType: reading.type,
                              );
                            });
                      } else {
                        return Container();
                      }
                    });
              }),
              Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: Divider(
                      color: Theme.of(context).shadowColor,
                      thickness: 1,
                    ),
                  ),
                  Text(
                    ' Diary Entries ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).shadowColor,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Theme.of(context).shadowColor,
                      thickness: 1,
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              IntrinsicHeight(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  // height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // color: Theme.of(context).secondaryHeaderColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DiaryListBuilder(
                        patient: widget.patient,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ));
  }
}

Widget buildPopUpTextFormFields({
  required TextEditingController entryController,
  required TextEditingController commentController,
  required MedicalReadingType medicalReadingType,
  required BuildContext context,
}) {
  return Column(
    children: [
      TextFormField(
        controller: entryController,
        decoration: InputDecoration(
          labelText: '${medicalReadingType.tag} (${medicalReadingType.unit})',
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
        style: Theme.of(context).textTheme.bodyMedium,
        controller: commentController,
        decoration: InputDecoration(
          labelText: 'Comment',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ],
  );
}
