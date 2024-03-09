import 'package:intl/intl.dart';

class DateService {
  static const Duration _timeLimit = Duration(seconds: 10);

  static Duration get timeLimit => _timeLimit;

  // to get start of the week of a given date
  static DateTime getStartOfWeek(DateTime date) {
    DateTime startOfWeek = date;
    startOfWeek = startOfWeek.subtract(Duration(days: startOfWeek.weekday - 1));
    startOfWeek = DateTime(
        startOfWeek.year, startOfWeek.month, startOfWeek.day, 0, 0, 0, 0, 0);
    return startOfWeek;
  }

  // to get start of the day
  static DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 0, 0, 0, 0, 0);
  }

  // formatting the time with 10:00 AM/PM format
  static String getFormattedTimeWithAMPM(DateTime time) {
    DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(time);
  }

  // formatting the date with 10th Jan 2021 format
  static String getFormattedDate(DateTime date) {
    DateFormat formatter = DateFormat('d MMM y');
    return formatter.format(date);
  }
}
