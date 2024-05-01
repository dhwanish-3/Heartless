import 'package:flutter/material.dart';
import 'package:heartless/services/date/date_service.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:heartless/widgets/analytics/week_selector_widget.dart';
import 'package:provider/provider.dart';

class YearMonthWeekSelector extends StatefulWidget {
  const YearMonthWeekSelector({
    super.key,
  });

  @override
  State<YearMonthWeekSelector> createState() => _YearMonthWeekSelectorState();
}

class _YearMonthWeekSelectorState extends State<YearMonthWeekSelector> {
  final int startYear = 2022;
  int currentYear = DateTime.now().year;
  final int startMonth = 3; // March

  int currentMonth = DateTime.now().month;
  late WidgetNotifier widgetNotifier;
  late PageController _pageController;
  late List<String> months;
  late List<int> years =
      List<int>.generate(currentYear - startYear + 1, (i) => startYear + i);

  @override
  void initState() {
    super.initState();
    widgetNotifier = Provider.of<WidgetNotifier>(context, listen: false);
    DateService.getMonthConsideringMonday((month, year) {
      currentMonth = month;
      currentYear = year;
      widgetNotifier.setAnalyticsSelectedYearWithoutNotifying(year);
      widgetNotifier.setAnalyticsSelectedMonthWithoutNotifying(
          DateService.getMonthFormatMMM(month));
    });
    months = DateService.getMonths(
      widgetNotifier.analyticsSelectedYear,
      currentYear,
      startYear,
      startMonth,
      currentMonth,
    );
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void updateDates(
    String startDay,
    String endDay,
  ) {
    DateTime tempStartDate = DateService.convertWeekSelectorFormatToDate(
        widgetNotifier.analyticsSelectedYear,
        widgetNotifier.analyticsSelectedMonth,
        startDay);

    //* endDate is currently not used. Should it be used later on edgecases for start and endDate being in different years have to be handled
    /*
    DateTime tempEndDate = DateService.convertWeekSelectorFormatToDate(
        widgetNotifier.analyticsSelectedYear,
        widgetNotifier.analyticsSelectedMonth,
        endDay);
    //check if tempEndDate is smaller than tempStartDate

    if (tempEndDate.isBefore(tempStartDate)) {
      tempEndDate =
          DateTime(tempEndDate.year, tempEndDate.month + 1, tempEndDate.day);
    }
    */

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widgetNotifier.setAnalyticsStartDate(tempStartDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WidgetNotifier>(builder: (context, value, child) {
      return Container(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: dropDownWidget(context, years,
                  widgetNotifier.analyticsSelectedYear.toString(), (value) {
                widgetNotifier.setAnalyticsSelectedYearWithoutNotifying(value);
                // months = DateService.getMonths(
                //   widgetNotifier.analyticsSelectedYear,
                //   currentYear,
                //   startYear,
                //   startMonth,
                //   currentMonth,
                // );
                if (!months.contains(widgetNotifier.analyticsSelectedMonth)) {
                  widgetNotifier
                      .setAnalyticsSelectedMonthWithoutNotifying(months[0]);
                }
                int monthIndex = DateService.getMonthNumber(months[0]);

                if (_pageController.hasClients) {
                  _pageController.jumpToPage(0);
                }
                widgetNotifier
                    .setAnalyticsStartDate(DateTime(value, monthIndex, 1));
              }),
            ),
            const SizedBox(width: 5),
            Expanded(
                flex: 1,
                child: dropDownWidget(
                    context, months, widgetNotifier.analyticsSelectedMonth,
                    (value) {
                  widgetNotifier.setAnalyticsSelectedMonth(value);
                  int monthIndex = DateService.getMonthNumber(value);
                  if (_pageController.hasClients) {
                    _pageController.jumpToPage(0);
                  }
                  widgetNotifier.setAnalyticsStartDate(DateTime(
                      widgetNotifier.analyticsSelectedYear, monthIndex, 1));
                })),
            const SizedBox(width: 5),
            Expanded(
              flex: 2,
              child: WeekSelectorWidget(
                pageController: _pageController,
                month: DateService.getMonthNumber(
                    widgetNotifier.analyticsSelectedMonth),
                year: widgetNotifier.analyticsSelectedYear,
                updateDates: updateDates,
              ),
            ),
          ],
        ),
      );
    });
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
        color: Theme.of(context).shadowColor,
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
