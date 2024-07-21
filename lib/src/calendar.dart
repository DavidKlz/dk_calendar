import 'package:flutter/material.dart';

import 'data/calendar_entry.dart';
import 'utils/enums/calendar_view.dart';
import 'views/day_view/calendar_day_view.dart';
import 'views/calendar_month_view.dart';
import 'views/calendar_week_view.dart';
import 'commons/calendar_header.dart';

// TODO: !! DO INTERNATIONALIZATION (⌐■_■) !!

class Calendar extends StatefulWidget {
  Calendar({
    required this.view,
    DateTime? displayDate,
    List<CalendarEntry>? entries,
    this.showHeader = true,
    this.header,
    super.key,
  })  : entries = entries ?? [],
        displayDate = displayDate ?? DateTime.now();

  final DateTime displayDate;
  final bool showHeader;
  final Widget? header;
  final List<CalendarEntry> entries;

  final CalendarView view;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime displayDate = DateTime.now();
  CalendarView currentView = CalendarView.month;

  @override
  void initState() {
    currentView = widget.view;
    displayDate = widget.displayDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          if (widget.showHeader)
            (widget.header != null)
                ? SizedBox(
                    height: constraints.maxHeight * 0.1, child: widget.header!)
                : SizedBox(
                    height: constraints.maxHeight * 0.1,
                    child: CalendarHeader(
                      view: currentView,
                      date: displayDate,
                      onLeftPressed: _previousDate,
                      onRightPressed: _nextDate,
                      onTodayPressed: _jumpToToday,
                      onSelectView: _changeView,
                    ),
                  ),
          SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight * 0.9,
            child: _getView(),
          ),
        ],
      );
    });
  }

  Widget _getView() {
    switch (currentView) {
      case CalendarView.day:
        return CalendarDayView(
          entries: [CalendarEntry(name: "Test", startDate: DateTime(2024, 7, 20, 16), endDate: DateTime(2024, 7, 20, 17, 00))],
          displayDate: displayDate,
        );
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
        return CalendarWeekView();
    }
  }

  _nextDate() {
    switch (currentView) {
      case CalendarView.day:
      case CalendarView.timelineDay:
        _nextDay();
      case CalendarView.week:
      case CalendarView.timelineWeek:
        _nextWeek();
      case CalendarView.month:
        _nextMonth();
    }
  }

  _previousDate() {
    switch (currentView) {
      case CalendarView.day:
      case CalendarView.timelineDay:
        _previousDay();
      case CalendarView.week:
      case CalendarView.timelineWeek:
        _previousWeek();
      case CalendarView.month:
        _previousMonth();
    }
  }

  void _changeView(CalendarView? newView) {
    if (newView != null) {
      setState(() => currentView = newView);
    }
  }

  void _jumpToToday() {
    setState(() {
      displayDate = DateTime.now();
    });
  }

  _nextDay() {
    setState(() {
      displayDate = DateTime(displayDate.year, displayDate.month,
          displayDate.day + 1, displayDate.hour, displayDate.minute);
    });
  }

  _previousDay() {
    setState(() {
      displayDate = DateTime(displayDate.year, displayDate.month,
          displayDate.day - 1, displayDate.hour, displayDate.minute);
    });
  }

  _nextWeek() {
    setState(() {
      displayDate = DateTime(
          displayDate.year,
          displayDate.month,
          displayDate.day + DateTime.daysPerWeek,
          displayDate.hour,
          displayDate.minute);
    });
  }

  _previousWeek() {
    setState(() {
      displayDate = DateTime(
          displayDate.year,
          displayDate.month,
          displayDate.day - DateTime.daysPerWeek,
          displayDate.hour,
          displayDate.minute);
    });
  }

  _nextMonth() {
    setState(() {
      displayDate = DateTime(displayDate.year, displayDate.month + 1,
          displayDate.day, displayDate.hour, displayDate.minute);
    });
  }

  _previousMonth() {
    setState(() {
      displayDate = DateTime(displayDate.year, displayDate.month - 1,
          displayDate.day, displayDate.hour, displayDate.minute);
    });
  }
}
