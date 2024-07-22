import 'dart:math';
import 'dart:developer' as dev;

import 'package:dk_calendar/dk_calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../commons/filled_calendar_entry.dart';
import 'day_view_date.dart';
import 'line_painter.dart';

class CalendarDayView extends StatefulWidget {
  const CalendarDayView({
    required this.entries,
    required this.displayDate,
    this.dayMarkColor = Colors.blueAccent,
    this.hourSpace = 45,
    super.key,
  });

  final DateTime displayDate;
  final Color dayMarkColor;
  final List<CalendarEntry> entries;
  final double hourSpace;

  @override
  State<CalendarDayView> createState() => _CalendarDayViewState();
}

class _CalendarDayViewState extends State<CalendarDayView> {
  double draggedItemPosition = 0;

  double quarterHourSpace = 0;

  @override
  Widget build(BuildContext context) {
    quarterHourSpace = widget.hourSpace / 4;
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DayViewDate(
              displayDate: widget.displayDate,
              dayMarkColor: widget.dayMarkColor,
            ),
            const SizedBox(height: 5),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: widget.hourSpace * 24,
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: Size(constraints.maxWidth, widget.hourSpace * 24),
                        painter: LinePainter(
                          space: widget.hourSpace,
                        ),
                      ),
                      ..._createEntries(constraints.maxWidth - 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  List<Widget> _createEntries(double width) {
    return widget.entries.map(
          (e) {
        return Positioned(
          top: _getEntryPosition(e),
          child: GestureDetector(
            onVerticalDragStart: (details) => _dragStart(e, details),
            onVerticalDragUpdate: (details) => _dragUpdate(e, details),
            onVerticalDragEnd: (details) => _dragEnd(e, details),
            onVerticalDragCancel: () => _dragCancel(e),
            child: FilledCalendarEntry(
              padding: const EdgeInsets.all(8),
              entry: e,
              width: width,
              showTime: true,
              hourSpace: widget.hourSpace,
            ),
          ),
        );
      },
    ).toList();
  }

  _dragStart(CalendarEntry entry, DragStartDetails details) {
    draggedItemPosition = _getEntryPosition(entry);
  }

  _dragUpdate(CalendarEntry entry, DragUpdateDetails details) {
    setState(() {
      draggedItemPosition = draggedItemPosition + details.delta.dy;
      double position = _getClosesSnappingPoint() - _getEntryPosition(entry);
      var minutes = ((position / widget.hourSpace) * 60).round();
      entry.startDate = entry.startDate.add(Duration(minutes: minutes));
      entry.endDate = entry.endDate?.add(Duration(minutes: minutes));
    });
  }

  _dragEnd(CalendarEntry entry, DragEndDetails details) {
    // TODO
  }

  _dragCancel(CalendarEntry entry) {
    // TODO
  }

  double _getEntryPosition(CalendarEntry e) {
    return widget.hourSpace *
        ((e.startDate.hour * 60 + e.startDate.minute) / 60);
  }

  double _getClosesSnappingPoint() {
    return quarterHourSpace * (draggedItemPosition / quarterHourSpace).round();
  }
}
