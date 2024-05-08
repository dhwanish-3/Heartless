import 'package:intl/intl.dart';

class DateService {
  static const Duration _timeLimit = Duration(seconds: 10);

  static Duration get timeLimit => _timeLimit;

  // to get start of the month of a given date
  static DateTime getStartOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1, 0, 0, 0, 0, 0);
  }

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
  static String getFormattedTime(DateTime time) {
    DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(time);
  }

  static String dayDateTimeFormat(DateTime timestamp) {
    return DateFormat('EEEE, d MMMM yyyy h:mm a').format(timestamp);
  }

  // formatting the time with Yesterday/Today/24 Feb 2024 10:00 AM/PM format
  static String getRelativeDateWithTime(DateTime time) {
    DateTime now = DateTime.now();
    DateTime startOfToday = getStartOfDay(now);
    DateTime startOfYesterday = startOfToday.subtract(const Duration(days: 1));

    if (time.isAfter(startOfToday)) {
      return 'Today ${getFormattedTime(time)}';
    } else if (time.isAfter(startOfYesterday)) {
      return 'Yesterday ${getFormattedTime(time)}';
    } else {
      DateFormat formatter = DateFormat('dd MMM yyyy hh:mm a');
      return formatter.format(time);
    }
  }

  // formatting the date time with Yesterday/Today/24 Feb 2024 format
  static String getRelativeDate(DateTime time) {
    DateTime now = DateTime.now();
    DateTime startOfToday = getStartOfDay(now);
    DateTime startOfYesterday = startOfToday.subtract(const Duration(days: 1));

    if (time.isAfter(startOfToday)) {
      return 'Today';
    } else if (time.isAfter(startOfYesterday)) {
      return 'Yesterday';
    } else {
      DateFormat formatter = DateFormat('dd MMM yyyy');
      return formatter.format(time);
    }
  }

  static String getRelativeTimeInWording(DateTime time) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(time);
    if (difference < _timeLimit) {
      return 'Just Now';
    } else if (difference.inMinutes < 60) {
      if (difference.inMinutes == 1)
        return 'One minute ago';
      else
        return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      if (difference.inHours == 1)
        return 'One hour ago';
      else
        return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      if (difference.inDays == 1)
        return 'Yesterday';
      else
        return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      if ((difference.inDays / 7).floor() == 1)
        return 'One week ago';
      else
        return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays < 365) {
      if ((difference.inDays / 30).floor() == 1)
        return 'One month ago';
      else
        return '${(difference.inDays / 30).floor()} months ago';
    } else {
      if ((difference.inDays / 365).floor() == 1)
        return 'One year ago';
      else
        return '${(difference.inDays / 365).floor()} years ago';
    }
  }

  //a function which takes as input DateTime and returns string of the format, 7 Sun, 1 Tue
  static String weekSelectorFormat(DateTime date) {
    return '${date.day} ${DateFormat('E').format(date)}';
  }

  static const monthNumbers = {
    'JAN': 1,
    'FEB': 2,
    'MAR': 3,
    'APR': 4,
    'MAY': 5,
    'JUN': 6,
    'JUL': 7,
    'AUG': 8,
    'SEP': 9,
    'OCT': 10,
    'NOV': 11,
    'DEC': 12,
  };

  static const List<String> monthsFormatMMM = [
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
  // from year in the int 2023, month in the String JAN, FEB, and day in String 5 Mon, 7 Wed ..to type DateTime
  static DateTime convertWeekSelectorFormatToDate(
      int year, String month, String day) {
    // Map of month abbreviations to month numbers

    // Extract the day number from the day string
    int dayNumber = int.parse(day.split(' ')[0]);

    // Convert the month string to a month number
    int monthNumber = monthNumbers[month.toUpperCase()] ?? 1;

    // Create a DateTime object
    return DateTime(year, monthNumber, dayNumber);
  }

  static int getMonthNumber(String month) {
    return monthNumbers[month.toUpperCase()] ?? 0;
  }

  static String getMonthFormatMMM(int month) {
    return monthsFormatMMM[month - 1];
  }

  static List<String> getMonths(
    int selectedYear,
    int currentYear,
    int startYear,
    int startMonth,
    int currentMonth,
  ) {
    if (selectedYear == startYear && selectedYear == currentYear) {
      return monthsFormatMMM.sublist(startMonth - 1, currentMonth);
    } else if (selectedYear == startYear) {
      return monthsFormatMMM.sublist(startMonth - 1);
    } else if (selectedYear == currentYear) {
      return monthsFormatMMM.sublist(0, currentMonth);
    } else {
      return monthsFormatMMM;
    }
  }

  static //if the Monday of the week started on the last month then currentMonth should be the last month. Also considering edgeCase
      void getMonthConsideringMonday(void callBack(int month, int year)) {
    DateTime now = DateTime.now();
    int currentYear = now.year;
    DateTime mondayOfThisWeek = now.subtract(Duration(days: now.weekday - 1));

    if (mondayOfThisWeek.month != now.month) {
      if (now.month == 1)
        callBack(12, currentYear - 1);
      else
        callBack(now.month - 1, currentYear);
      return;
    } else {
      callBack(now.month, currentYear);
      return;
    }
  }

  static DateTime findNextMonday(int year, int month) {
    // Start from the first day of the given month and year
    DateTime date = DateTime(year, month, 1);

    // While the weekday is not Monday (1 represents Monday in DateTime)
    while (date.weekday != DateTime.monday) {
      // Go to the next day
      date = date.add(Duration(days: 1));
    }

    // Return the date of the next Monday
    return date;
  }
}
