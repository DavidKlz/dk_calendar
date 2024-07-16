import 'package:flutter/material.dart';

import 'data/calendar_entry.dart';
import 'utils/enums/calendar_view.dart';
import 'views/calendar_day_view.dart';
import 'views/calendar_month_view.dart';
import 'views/calendar_week_view.dart';
import 'views/widgets/calendar_header.dart';

class Calendar extends StatefulWidget {
  Calendar({
    required this.view,
    DateTime? displayDate,
    Map<DateTime, List<CalendarEntry>>? entries,
    this.showHeader = true,
    this.header,
    super.key,
  })  : entries = entries ?? {},
        displayDate = displayDate ?? DateTime.now();

  final DateTime displayDate;
  final bool showHeader;
  final Widget? header;
  final Map<DateTime, List<CalendarEntry>> entries;

  final CalendarView view;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime displayDate = DateTime.now();

  @override
  void initState() {
    displayDate = widget.displayDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showHeader)
          (widget.header != null)
              ? widget.header!
              : CalendarHeader(
                  view: widget.view,
                  date: displayDate,
                  onLeftPressed: _previousMonth,
                  onRightPressed: _nextMonth,
                  onTodayPressed: _jumpToToday,
                ),
        Expanded(child: _getView()),
      ],
    );
  }

  Widget _getView() {
    switch (widget.view) {
      case CalendarView.day:
        return CalendarDayView();
      case CalendarView.week:
        return CalendarWeekView();
      case CalendarView.month:
        return CalendarMonthView(
          displayDate: displayDate,
          entries: widget.entries,
        );
      case CalendarView.timelineDay:
      // TODO: Handle this case.
      case CalendarView.timelineWeek:
      // TODO: Handle this case.
      case CalendarView.timelineMonth:
        // TODO: Handle this case.
        return CalendarWeekView();
    }
  }

  void _jumpToToday() {
    setState(() {
      displayDate = DateTime.now();
    });
  }

  void _nextMonth() {
    setState(() {
      displayDate = DateTime(displayDate.year, displayDate.month + 1,
          displayDate.day, displayDate.hour, displayDate.minute);
    });
  }

  void _previousMonth() {
    setState(() {
      displayDate = DateTime(displayDate.year, displayDate.month - 1,
          displayDate.day, displayDate.hour, displayDate.minute);
    });
  }
}
