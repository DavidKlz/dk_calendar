class CalendarDateUtils {
  CalendarDateUtils._();

  static List<DateTime> getMonthDateTimesFor(DateTime dateTime) {
    List<DateTime> monthDateTimes = List.empty(growable: true);
    var firstDate = _findFirstDateOfTheWeek(_findFirstDateOfTheMonth(dateTime));
    var lastDate = _findLastDateOfTheWeek(_findLastDateOfTheMonth(dateTime));
    var currentDate = firstDate;
    while(currentDate.isBefore(lastDate) || currentDate.isAtSameMomentAs(lastDate)) {
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