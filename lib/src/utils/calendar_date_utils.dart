import 'package:intl/intl.dart';

class CalendarDateUtils {
  CalendarDateUtils._();

  static String getWeekDayString(int weekday, {bool abbreviated = true}) {
    switch(weekday) {
      case DateTime.monday:
        return abbreviated ? "Mo" : "Montag";
      case DateTime.tuesday:
        return abbreviated ? "Di" : "Dienstag";
      case DateTime.wednesday:
        return abbreviated ? "Mi" : "Mittwoch";
      case DateTime.thursday:
        return abbreviated ? "Do" : "Donnerstag";
      case DateTime.friday:
        return abbreviated ? "Fr" : "Freitag";
      case DateTime.saturday:
        return abbreviated ? "Sa" : "Samstag";
      case DateTime.sunday:
        return abbreviated ? "So" : "Sonntag";
      default:
        return "";
    }
  }

  static String getMonthString(int month) {
    switch(month) {
      case DateTime.january:
        return "Januar";
      case DateTime.february:
        return "Februar";
      case DateTime.march:
        return "März";
      case DateTime.april:
        return "April";
      case DateTime.may:
        return "Mai";
      case DateTime.june:
        return "Juni";
      case DateTime.july:
        return "Juli";
      case DateTime.august:
        return "August";
      case DateTime.september:
        return "September";
      case DateTime.october:
        return "Oktober";
      case DateTime.november:
        return "November";
      case DateTime.december:
        return "Dezember";
      default:
        return "";
    }
  }

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
    while(currentDate.isBefore(lastDate) || (currentDate.day == lastDate.day && currentDate.month == lastDate.month && currentDate.year == lastDate.year && currentDate.hour <= 1)) {
      monthDateTimes.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }
    return monthDateTimes;
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