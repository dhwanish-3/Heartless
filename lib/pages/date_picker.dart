import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({Key? key}) : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? selectedDate;
  List<String> chosenDates = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
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
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio:
                      3.0, // Adjust this value for the desired height
                ),
                itemCount: chosenDates.length,
                itemBuilder: (context, index) {
                  return _buildDateCard(chosenDates[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard(String date, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Constants.primaryColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            date,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              _removeDate(index);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2101),
    );

    if (picked != null && !chosenDates.contains(picked.toString())) {
      setState(() {
        chosenDates.add(picked.toString().substring(0, 10));
      });
    }
  }

  void _removeDate(int index) {
    setState(() {
      chosenDates.removeAt(index);
    });
  }
}

void main() {
  runApp(const MaterialApp(
    home: DatePicker(),
  ));
}
