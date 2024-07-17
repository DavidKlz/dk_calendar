enum Weekday {
  monday("Monday", "Mon"),
  tuesday("Tuesday", "Tue"),
  wednesday("Wednesday", "Wed"),
  thursday("Thursday", "Thu"),
  friday("Friday", "Fri"),
  saturday("Saturday", "Sat"),
  sunday("Sunday", "Sun");

  final String displayName;
  final String abbreviatedDisplayName;

  const Weekday(this.displayName, this.abbreviatedDisplayName);

  static String getWeekday(int index) {
    return Weekday.values
        .firstWhere(
          (element) => element.index + 1 == index,
          orElse: () => Weekday.monday,
        )
        .displayName;
  }

  static String getAbbreviatedWeekday(int index) {
    return Weekday.values
        .firstWhere((element) => element.index + 1 == index,
            orElse: () => Weekday.monday)
        .abbreviatedDisplayName;
  }
}
