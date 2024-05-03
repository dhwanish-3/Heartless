import 'package:flutter/material.dart';
import 'package:heartless/services/date/date_service.dart';
import 'package:heartless/shared/provider/analytics_provider.dart';
import 'package:provider/provider.dart';

class WeekSelectorWidget extends StatefulWidget {
  final PageController pageController;

  final Function(
    String startDay,
    String endDay,
  ) updateDates;
  const WeekSelectorWidget({
    super.key,
    required this.updateDates,
    required this.pageController,
  });

  @override
  State<WeekSelectorWidget> createState() => _WeekSelectorWidgetState();

  // returns a list of ranges of dates of each week
  List<List<String>> getWeeks(
      int year, int month, void callBack(int weekIndex)) {
    List<List<String>> weeks = [];
    String monthStr = month < 10
        ? '0$month'
        : month.toString(); // Pad the month with a leading zero if necessary
    DateTime firstDay = DateTime.parse('${year}-${monthStr}-01');
    DateTime lastDay = DateTime.parse(
        '${year}-${monthStr}-${DateTime(year, month + 1, 0).day}');

    int weekIndex = 0;
    // Find the most recent Monday
    while (firstDay.weekday != DateTime.monday) {
      firstDay = firstDay.add(Duration(days: 1));
    }

    DateTime currentDay = firstDay;
    DateTime now = DateTime.now();
    while (currentDay.isBefore(lastDay)) {
      DateTime weekStart = currentDay;
      DateTime weekEnd = currentDay.add(Duration(days: 6));

      //* should be uncommented after we are specifying the start date and enddate for graph widgets
      if (weekStart.isAfter(now)) {
        break;
      }
      weeks.add([
        DateService.weekSelectorFormat(weekStart),
        DateService.weekSelectorFormat(weekEnd),
      ]);
      if (now.isAfter(weekStart) &&
          now.isBefore(weekEnd.add(Duration(days: 1)))) {
        callBack(weekIndex);
      }
      weekIndex = weekIndex + 1;
      currentDay = weekEnd.add(Duration(days: 1));
    }
    return weeks;
  }
}

class _WeekSelectorWidgetState extends State<WeekSelectorWidget> {
  int currentWeekIndex = -1;
  List<List<String>> weeks = [];

  @override
  void initState() {
    super.initState();

    AnalyticsNotifier analyticsNotifier =
        Provider.of<AnalyticsNotifier>(context, listen: false);
    int year = analyticsNotifier.selectedYear;
    int month = analyticsNotifier.selectedMonth;

    weeks = widget.getWeeks(year, month, (weekIndex) {
      currentWeekIndex = weekIndex;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.pageController.hasClients && currentWeekIndex != -1) {
        widget.pageController.jumpToPage(currentWeekIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AnalyticsNotifier analyticsNotifier =
        Provider.of<AnalyticsNotifier>(context, listen: false);
    int year = analyticsNotifier.selectedYear;
    int month = analyticsNotifier.selectedMonth;

    weeks = widget.getWeeks(year, month, (weekIndex) {
      currentWeekIndex = weekIndex;
    });

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (widget.pageController.hasClients && currentWeekIndex != -1) {
    //     widget.pageController.jumpToPage(currentWeekIndex);
    //   }
    // });
    return WeekSliderWidget(
      weeks: weeks,
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
      padding: const EdgeInsets.all(2),
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
              onPageChanged: (index) {
                if (index < weeks.length && index >= 0) {
                  onWeekChanged(weeks[index][0], weeks[index][1]);
                }
              },
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(0),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text('${weeks[index][0]} - ${weeks[index][1]}',
                        style: TextStyle(
                          fontSize: 16,
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
