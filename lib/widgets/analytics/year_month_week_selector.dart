import 'package:flutter/material.dart';
import 'package:heartless/services/date/date_service.dart';
import 'package:heartless/shared/provider/analytics_provider.dart';
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
  final int startMonth = 3; // March

  final DateTime startOfWeek = DateService.getStartOfWeek(DateTime.now());

  late PageController _pageController;
  late List<String> months;
  late List<int> years = List<int>.generate(
      startOfWeek.year - startYear + 1, (i) => startYear + i);

  @override
  void initState() {
    super.initState();
    AnalyticsNotifier analyticsNotifier =
        Provider.of<AnalyticsNotifier>(context, listen: false);

    analyticsNotifier.setSelectedDateWithoutNotifying(startOfWeek);
    analyticsNotifier.setSelectedYearWithoutNotifying(startOfWeek.year);
    analyticsNotifier.setSelectedMonthWithoutNotifying(startOfWeek.month);

    months = DateService.getMonths(
      analyticsNotifier.selectedYear,
      startOfWeek.year,
      startYear,
      startMonth,
      startOfWeek.month,
    );
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AnalyticsNotifier analyticsNotifier =
        Provider.of<AnalyticsNotifier>(context, listen: false);

    void updateDates(
      String startDay,
      String endDay,
    ) {
      DateTime startDate = DateService.convertWeekSelectorFormatToDate(
          analyticsNotifier.selectedYear,
          DateService.getMonthFormatMMM(analyticsNotifier.selectedMonth),
          startDay);
//* should the interval be specified, logic for endDate to be included here

      WidgetsBinding.instance.addPostFrameCallback((_) {
        // analyticsNotifier.setSelectedDateWithoutNotifying(startDate);
        analyticsNotifier.setDate(startDate);
      });
    }

    return Consumer<AnalyticsNotifier>(builder: (context, value, child) {
      return Container(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: dropDownWidget(
                  context, years, analyticsNotifier.selectedYear.toString(),
                  (value) {
                analyticsNotifier.setYear(value);
                months = DateService.getMonths(
                  analyticsNotifier.selectedYear,
                  startOfWeek.year,
                  startYear,
                  startMonth,
                  startOfWeek.month,
                );
                int monthIndex = DateService.getMonthNumber(months[0]);
                if (!months.contains(DateService.getMonthFormatMMM(
                    analyticsNotifier.selectedMonth))) {
                  analyticsNotifier.setMonth(monthIndex);
                } else {
                  monthIndex = DateService.getMonthNumber(
                      DateService.getMonthFormatMMM(
                          analyticsNotifier.selectedMonth));
                }

                if (_pageController.hasClients) {
                  _pageController.jumpToPage(0);
                }
                analyticsNotifier.setDate(DateTime(value, monthIndex, 1));
              }),
            ),
            const SizedBox(width: 5),
            Expanded(
                flex: 1,
                child: dropDownWidget(
                    context,
                    months,
                    DateService.getMonthFormatMMM(
                        analyticsNotifier.selectedMonth), (value) {
                  analyticsNotifier.setMonth(DateService.getMonthNumber(value));

                  int monthIndex = DateService.getMonthNumber(value);
                  if (_pageController.hasClients) {
                    _pageController.jumpToPage(0);
                  }
                  analyticsNotifier.setDate(
                      DateTime(analyticsNotifier.selectedYear, monthIndex, 1));
                })),
            const SizedBox(width: 5),
            Expanded(
              flex: 2,
              child: WeekSelectorWidget(
                pageController: _pageController,
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
