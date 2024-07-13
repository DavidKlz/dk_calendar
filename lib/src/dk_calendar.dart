import 'package:flutter/material.dart';

import 'utils/enums/calendar_view.dart';
import 'views/calendar_day_view.dart';
import 'views/calendar_month_view.dart';
import 'views/calendar_week_view.dart';

class DkCalendar extends StatefulWidget {
  const DkCalendar({
    required this.view,
    super.key,
  });

  final CalendarView view;

  @override
  State<DkCalendar> createState() => _DkCalendarState();
}

class _DkCalendarState extends State<DkCalendar> {
  @override
  Widget build(BuildContext context) {
    switch(widget.view) {
      case CalendarView.day:
        return CalendarDayView();
      case CalendarView.week:
        return CalendarWeekView();
      case CalendarView.month:
        return CalendarMonthView();
      case CalendarView.timelineDay:
        // TODO: Handle this case.
      case CalendarView.timelineWeek:
        // TODO: Handle this case.
      case CalendarView.timelineMonth:
        // TODO: Handle this case.
        return CalendarWeekView();
    }
  }
}
