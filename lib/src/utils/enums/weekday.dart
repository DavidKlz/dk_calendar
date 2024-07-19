enum Weekday {
  monday("Monday", "MON"),
  tuesday("Tuesday", "TUE"),
  wednesday("Wednesday", "WED"),
  thursday("Thursday", "THU"),
  friday("Friday", "FRI"),
  saturday("Saturday", "SAT"),
  sunday("Sunday", "SUN");

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
