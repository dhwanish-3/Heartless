import 'package:flutter/material.dart';
import 'package:calendar_slider/calendar_slider.dart';
import 'package:heartless/main.dart';
import 'package:heartless/shared/provider/widget_provider.dart';

class HorizontalCalendar extends StatefulWidget {
  const HorizontalCalendar({super.key});

  @override
  State<HorizontalCalendar> createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  final CalendarSliderController _calendarSliderControllerNotAppBar =
      CalendarSliderController();

  @override
  Widget build(BuildContext context) {
    WidgetNotifier widgetNotifier = Provider.of<WidgetNotifier>(context);
    return CalendarSlider(
      backgroundColor: Colors.transparent,
      dateColor: Colors.black,
      controller: _calendarSliderControllerNotAppBar,
      locale: 'en',
      weekDay: WeekDay.short,
      // fullCalendarDay: WeekDay.short,
      selectedDateColor: Colors.white,
      selectedDayPosition: SelectedDayPosition.center,
      initialDate: widgetNotifier.selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 180)),
      lastDate: DateTime.now().add(const Duration(days: 180)),
      fullCalendarScroll: FullCalendarScroll.horizontal,
      onDateSelected: (date) {
        setState(() {
          widgetNotifier.setSelectedDate(date);
        });
      },
    );
  }
}
