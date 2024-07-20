import 'package:intl/intl.dart';

class CalendarDateUtils {
  CalendarDateUtils._();

  /// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  static int _numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  /// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
  static int getWeekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    int woy =  ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = _numOfWeeks(date.year - 1);
    } else if (woy > _numOfWeeks(date.year)) {
      woy = 1;
    }
    return woy;
  }

  static List<DateTime> getMonthDateTimesFor(DateTime dateTime) {
    List<DateTime> monthDateTimes = List.empty(growable: true);
    var firstDate = _findFirstDateOfTheWeek(_findFirstDateOfTheMonth(dateTime));
    var lastDate = _findLastDateOfTheWeek(_findLastDateOfTheMonth(dateTime));
    var currentDate = firstDate;
    while(currentDate.isBefore(lastDate) || (isSameDay(currentDate, lastDate) && currentDate.hour <= 1)) {
      monthDateTimes.add(currentDate);
      currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day + 1);
    }
    return monthDateTimes;
  }

  static bool isSameDay(DateTime date1, date2) {
    return (date1.day == date2.day && date1.month == date2.month && date1.year == date2.year);
  }

  static DateTime _findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  static DateTime _findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  static DateTime _findFirstDateOfTheMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, 1);
  }

  static DateTime _findLastDateOfTheMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month + 1, 0);
  }
}