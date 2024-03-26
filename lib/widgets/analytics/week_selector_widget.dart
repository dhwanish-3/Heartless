import 'package:flutter/material.dart';
import 'package:heartless/services/date/date_service.dart';

class WeekSelectorWidget extends StatefulWidget {
  final int month;
  final int year;
  final PageController pageController;
  final Function(
    String startDay,
    String endDay,
  ) updateDates;
  const WeekSelectorWidget({
    super.key,
    required this.month,
    required this.year,
    required this.updateDates,
    required this.pageController,
  });

  @override
  State<WeekSelectorWidget> createState() => _WeekSelectorWidgetState();

  // returns a list of ranges of dates of each week
  List<List<String>> getWeeks() {
    List<List<String>> weeks = [];
    String monthStr = month < 10
        ? '0$month'
        : month.toString(); // Pad the month with a leading zero if necessary
    DateTime firstDay = DateTime.parse('${year}-${monthStr}-01');
    DateTime lastDay = DateTime.parse(
        '${year}-${monthStr}-${DateTime(year, month + 1, 0).day}');
    DateTime currentDay = firstDay;
    DateTime now = DateTime.now();
    while (currentDay.isBefore(lastDay)) {
      DateTime weekStart = currentDay;
      DateTime weekEnd = currentDay.add(Duration(days: 6));
      if (weekStart.isAfter(now)) {
        break;
      }
      weeks.add([
        DateService.weekSelectorFormat(weekStart),
        DateService.weekSelectorFormat(weekEnd),
      ]);
      currentDay = weekEnd.add(Duration(days: 1));
    }
    return weeks;
  }
}

class _WeekSelectorWidgetState extends State<WeekSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    return WeekSliderWidget(
      weeks: widget.getWeeks(),
      pageController: widget.pageController,
      onWeekChanged: widget.updateDates,
    );
  }
}

class WeekSliderWidget extends StatelessWidget {
  final List<List<String>> weeks;
  final PageController pageController;
  final Function onWeekChanged;

  WeekSliderWidget({
    super.key,
    required this.weeks,
    required this.pageController,
    required this.onWeekChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (weeks.isNotEmpty) {
      // onWeekChanged(weeks[0][0], weeks[0][1]);
    }
    if (pageController.hasClients) {
      // pageController.jumpToPage(0);
      // onWeekChanged(weeks[0][0], weeks[0][1]);
    }
    return Container(
      height: 30,
      width: 200,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.arrow_left),
              onPressed: () {
                if (pageController.hasClients && pageController.page! > 0) {
                  int index = pageController.page!.toInt() - 1;
                  if (index < weeks.length && index >= 0) {
                    onWeekChanged(weeks[index][0], weeks[index][1]);
                  }
                  pageController.animateToPage(
                    (pageController.page! - 1).toInt(),
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: weeks.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(5),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text('${weeks[index][0]} - ${weeks[index][1]}',
                        style: TextStyle(
                          fontSize: 16,
                          // color: Colors.black,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                );
              },
            ),
          ),
          Container(
            width: 30,
            height: 30,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                if (pageController.hasClients &&
                    pageController.page! < weeks.length - 1) {
                  int index = pageController.page!.toInt() + 1;
                  if (index < weeks.length && index >= 0) {
                    onWeekChanged(weeks[index][0], weeks[index][1]);
                  }
                  pageController.animateToPage(
                    (pageController.page! + 1).toInt(),
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
