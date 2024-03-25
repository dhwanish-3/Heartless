import 'package:flutter/material.dart';
import 'package:heartless/services/date/date_service.dart';
import 'package:intl/intl.dart';

class DisplayModeSelector extends StatefulWidget {
  final Function onMonthYearChanged;
  const DisplayModeSelector({
    super.key,
    required this.onMonthYearChanged,
  });

  @override
  State<DisplayModeSelector> createState() => _DisplayModeSelectorState();
}

class _DisplayModeSelectorState extends State<DisplayModeSelector> {
  final List<String> months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC'
  ];

  final List<int> years =
      List<int>.generate(6, (i) => DateTime.now().year - 5 + i);

  String selectedMonth = DateFormat('MMM').format(DateTime.now()).toUpperCase();
  int selectedYear = DateTime.now().year;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // const SizedBox(width: 30),
        Expanded(
          flex: 1,
          child:
              dropDownWidget(context, years, selectedYear.toString(), (value) {
            setState(() {
              selectedYear = value;
            });
            // widget.onMonthYearChanged(selectedMonth, selectedYear);
          }),
        ),
        const SizedBox(width: 5),
        Expanded(
          flex: 1,
          child: dropDownWidget(context, months, selectedMonth, (value) {
            setState(() {
              selectedMonth = value;
            });

            // widget.onMonthYearChanged(selectedMonth, selectedYear);
          }),
        ),
        const SizedBox(width: 5),
        Expanded(
          flex: 2,
          child: WeekSelectorWidget(
            month: months.indexOf(selectedMonth) + 1,
            year: selectedYear,
          ),
        ),
        // const SizedBox(width: 30),
      ],
    );
  }

  Container dropDownWidget(
    BuildContext context,
    List items,
    String initialValue,
    Function onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.circular(10),
      ),
      width: 90,
      height: 30,
      padding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 2,
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                initialValue,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Container(
              width: 20,
              child: menuActionsWidget(context, items, initialValue, onChanged),
            )
          ]),
    );
  }
}

Widget menuActionsWidget(
  BuildContext parentContext,
  List<dynamic> items,
  String selectedItem,
  Function onChanged,
) {
  return Builder(
    builder: (context) {
      return IconButton(
        padding: EdgeInsets.zero,
        alignment: Alignment.center,
        iconSize: 20,
        color: Colors.black,
        icon: Icon(
          Icons.keyboard_arrow_down_outlined,
          size: 20,
        ),
        onPressed: () {
          final RenderBox button = context.findRenderObject() as RenderBox;
          final RenderBox overlay =
              Overlay.of(context).context.findRenderObject() as RenderBox;

          showMenu(
            context: context,
            position: RelativeRect.fromRect(
              Rect.fromPoints(
                button.localToGlobal(Offset.zero, ancestor: overlay),
                button.localToGlobal(button.size.bottomRight(Offset.zero),
                    ancestor: overlay),
              ),
              Offset.zero & overlay.size,
            ),
            items: <PopupMenuEntry>[
              for (int i = 0; i < items.length; i++)
                PopupMenuItem(
                  value: items[i],
                  onTap: () {
                    onChanged(items[i]);
                  },
                  child: Center(
                    child: Text(
                      items[i].toString(),
                      style: TextStyle(
                        color: Theme.of(parentContext).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      );
    },
  );
}

class WeekSelectorWidget extends StatefulWidget {
  final int month;
  final int year;
  const WeekSelectorWidget({
    super.key,
    required this.month,
    required this.year,
  });

  @override
  State<WeekSelectorWidget> createState() => _WeekSelectorWidgetState();

  // based on the given month and year, return a list of ranges of dates of each week
  List<List<String>> getWeeks() {
    List<List<String>> weeks = [];
    String monthStr = month < 10
        ? '0$month'
        : month.toString(); // Pad the month with a leading zero if necessary
    DateTime firstDay = DateTime.parse('${year}-${monthStr}-01');
    DateTime lastDay = DateTime.parse(
        '${year}-${monthStr}-${DateTime(year, month + 1, 0).day}');
    DateTime currentDay = firstDay;
    while (currentDay.isBefore(lastDay)) {
      DateTime weekStart = currentDay;
      DateTime weekEnd = currentDay.add(Duration(days: 6));
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
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _pageController.jumpToPage(0);
    return WeekSliderWidget(
      weeks: widget.getWeeks(),
      pageController: _pageController,
    );
  }
}

class WeekSliderWidget extends StatelessWidget {
  final List<List<String>> weeks;
  final PageController pageController;

  WeekSliderWidget({
    super.key,
    required this.weeks,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    // pageController.jumpToPage(0);
    if (pageController.hasClients) {
      pageController.jumpToPage(0);
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
