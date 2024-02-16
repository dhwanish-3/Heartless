class DateService {
  static const Duration _timeLimit = Duration(seconds: 10);

  static Duration get timeLimit => _timeLimit;

  // to get start of the week of a given date
  static DateTime getStartOfWeekOfDate(DateTime date) {
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

  // to get formatted date
  static String getFormattedDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
