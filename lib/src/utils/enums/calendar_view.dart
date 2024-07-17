enum CalendarView {
  day("Day"), week("Week"), month("Month"), timelineDay("Timeline Day"), timelineWeek("Timeline Week");

  final String displayName;

  const CalendarView(this.displayName);
}