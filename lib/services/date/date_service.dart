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
}
