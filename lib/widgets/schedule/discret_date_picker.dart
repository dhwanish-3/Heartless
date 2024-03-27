import 'package:flutter/material.dart';

class DiscreteDateSelector extends StatefulWidget {
  final List<DateTime> selectedDates;
  const DiscreteDateSelector({
    super.key,
    required this.selectedDates,
  });

  @override
  State<DiscreteDateSelector> createState() => _DiscreteDateSelectorState();
}

class _DiscreteDateSelectorState extends State<DiscreteDateSelector> {
  // List<DateTime> selectedDates = [];

  bool _isDateSelected(DateTime date) {
    return widget.selectedDates.contains(date);
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && !_isDateSelected(picked))
      setState(() {
        widget.selectedDates.add(picked);
      });
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 10,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          // height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            // color: Theme.of(context).secondaryHeaderColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).shadowColor,
              width: 0.6,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selected Dates',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).shadowColor,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      //show the Date Picker as Dialog and add the selected date to the list
                      _selectDate();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).highlightColor,
                              blurRadius: 0.5,
                              spreadRadius: 0.5,
                              offset: const Offset(1, -1),
                            )
                          ]),
                      child: Text(
                        'Add Date',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              widget.selectedDates.isEmpty
                  ? Container(
                      height: 30,
                      padding: const EdgeInsets.only(
                        left: 0,
                      ),
                      child: Text(
                        'Press Add Date to select a date.',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                    )
                  : Wrap(children: [
                      for (var date in widget.selectedDates)
                        Container(
                          margin: const EdgeInsets.only(
                            left: 0,
                            right: 5,
                            bottom: 10,
                          ),
                          padding: const EdgeInsets.only(
                            left: 10,
                            top: 5,
                            bottom: 5,
                            right: 5,
                          ),
                          decoration: BoxDecoration(
                            // color: Theme.of(context).primaryColor.withOpacity(0.2),
                            // color: Theme.of(context).shadowColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Theme.of(context).shadowColor,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                date.day.toString() +
                                    ' | ' +
                                    date.month.toString() +
                                    ' | ' +
                                    date.year.toString(),
                                style: TextStyle(
                                  color: Theme.of(context).shadowColor,
                                  // color: item.tagColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 5),
                              InkWell(
                                child: Icon(
                                  Icons.close,
                                  size: 20,
                                  color: Theme.of(context).shadowColor,
                                  // color: item.tagColor,
                                ),
                                onTap: () {
                                  setState(() {
                                    widget.selectedDates.remove(date);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                    ])
            ],
          )),
    );
  }
}
