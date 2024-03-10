import 'package:flutter/material.dart';
import 'package:heartless/main.dart';
import 'package:heartless/services/date/date_service.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/shared/provider/widget_provider.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({Key? key}) : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black), // Example border styling
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              _selectDate(context);
            },
            child: const Text('Pick A Date'),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Consumer<WidgetNotifier>(
              builder: (context, value, child) => GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio:
                      3.0, // Adjust this value for the desired height
                ),
                itemCount: widgetNotifier.chosenDates.length,
                itemBuilder: (context, index) {
                  return _buildDateCard(
                      widgetNotifier.chosenDates[index], widgetNotifier);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard(DateTime date, WidgetNotifier widgetNotifier) {
    return Container(
      decoration: BoxDecoration(
        color: Constants.primaryColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            DateService.getFormattedDate(date),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: () {
              widgetNotifier.removeChosenDate(date);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2101),
    );

    if (picked != null && !widgetNotifier.chosenDates.contains(picked)) {
      // setState(() {
      widgetNotifier.addChosenDate(picked);
      // });
    }
  }
}
