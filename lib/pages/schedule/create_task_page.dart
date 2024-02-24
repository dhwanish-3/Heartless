import 'package:flutter/material.dart';
import 'package:heartless/main.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:heartless/widgets/auth/text_input.dart';
import 'package:heartless/widgets/schedule/date_picker_button.dart';
import 'package:heartless/widgets/schedule/time_picker_button.dart';

class TaskFormPage extends StatefulWidget {
  const TaskFormPage({super.key});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String dateDropDownValue = 'Specify a Period';
  String typeDropDownValue = 'Exercise';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              // widgetNotifier.setWidget(WidgetType.schedule);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Center(
            child: Text(
              'Create Task',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // widgetNotifier.setWidget(WidgetType.schedule);
                }
              },
              icon: const Icon(Icons.save),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const SizedBox(height: 20),
                // Text(
                //   'Create Task',
                //   style: Theme.of(context).textTheme.displayLarge,
                // ),
                const SizedBox(height: 20),
                SelectorWidgetRow(
                    text: 'Category',
                    childWidget: Container(
                        padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).cardColor,
                          border: Border.all(
                            color: Theme.of(context).shadowColor,
                            width: 0.6,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Constants.customGray,
                              // color: Theme.of(context).shadowColor.withOpacity(0.5),
                              blurRadius: 1,
                              spreadRadius: 1,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: DropDownWidget(
                          dropdownItems: const [
                            'Medicine',
                            'Exercise',
                            'Food',
                            'Miscellaneous'
                          ],
                          dropdownValue: typeDropDownValue,
                          onChanged: (newValue) {
                            setState(() {
                              typeDropDownValue = newValue;
                              print("New Value at parent: $newValue");
                            });
                          },
                        ))),
                const SizedBox(height: 10),
                TextFieldInput(
                  textEditingController: _titleController,
                  hintText: 'Enter title of task',
                  labelText: 'Title',
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                TextFieldInput(
                  textEditingController: _descriptionController,
                  hintText: 'Instructions or Description',
                  labelText: 'Description',
                  maxLines: 2,
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                SelectorWidgetRow(
                  text: 'Time',
                  childWidget: TimePickerButton(
                    selectedTime: _selectedTime,
                    onTimeChanged: (newTime) {
                      setState(() {
                        _selectedTime = newTime;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SelectorWidgetRow(
                    text: 'Date',
                    childWidget: Container(
                        padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).cardColor,
                          border: Border.all(
                            color: Theme.of(context).shadowColor,
                            width: 0.6,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Constants.customGray,
                              // color: Theme.of(context).shadowColor.withOpacity(0.5),
                              blurRadius: 1,
                              spreadRadius: 1,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: DropDownWidget(
                          dropdownItems: const [
                            'Specify a Period',
                            'Selective Days'
                          ],
                          dropdownValue: dateDropDownValue,
                          onChanged: (newValue) {
                            setState(() {
                              dateDropDownValue = newValue;
                              print("New Value at parent: $newValue");
                            });
                          },
                        ))),
                const SizedBox(height: 20),
                dateDropDownValue == 'Specify a Period'
                    ? DateRangeSelector(
                        startDate: startDate,
                        endDate: endDate,
                        onStartDateChanged: (newDate) {
                          startDate = newDate;
                        },
                        onEndDateChanged: (newDate) {
                          endDate = newDate;
                        })
                    : Container(
                        width: 10,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DropDownWidget extends StatelessWidget {
  final String dropdownValue;
  final ValueChanged<String> onChanged;
  final List<String> dropdownItems;

  const DropDownWidget({
    super.key,
    required this.dropdownValue,
    required this.onChanged,
    required this.dropdownItems,
  });

  // String dropdownValue = 'Selective Days';
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      underline: Container(height: 0),
      value: dropdownValue,
      iconSize: 24,
      onChanged: (String? newValue) {
        onChanged(newValue!);
      },
      items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge,
              )),
        );
      }).toList(),
    );
  }
}

class SelectorWidgetRow extends StatelessWidget {
  final Widget childWidget;
  final String text;

  const SelectorWidgetRow({
    super.key,
    required this.childWidget,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: 30,
        ),
        Container(
            padding: const EdgeInsets.all(10),
            // width: 120,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).cardColor,
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).shadowColor,
                ),
              ),
            )),
        const SizedBox(width: 10),
        childWidget,
      ],
    );
  }
}

class DateRangeSelector extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final ValueChanged<DateTime> onStartDateChanged;
  final ValueChanged<DateTime> onEndDateChanged;

  const DateRangeSelector({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
  });

  @override
  _DateRangeSelectorState createState() => _DateRangeSelectorState();
}

class _DateRangeSelectorState extends State<DateRangeSelector> {
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectorWidgetRow(
          childWidget: Flexible(
            // Wrap DatePickerButton in Flexible
            child: DatePickerButton(
              selectedDate: _startDate,
              onChanged: (newDate) {
                setState(() {
                  _startDate = newDate;
                });
                widget.onStartDateChanged(newDate);
              },
            ),
          ),
          text: 'Start Date',
        ),
        const SizedBox(height: 20),
        SelectorWidgetRow(
          childWidget: Flexible(
            // Wrap DatePickerButton in Flexible
            child: DatePickerButton(
              selectedDate: _endDate,
              onChanged: (newDate) {
                setState(() {
                  _endDate = newDate;
                });
                widget.onEndDateChanged(newDate);
              },
            ),
          ),
          text: 'End Date  ',
        ),
      ],
    );
  }
}
