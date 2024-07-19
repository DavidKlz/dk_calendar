import 'package:dk_calendar/dk_calendar.dart';
import 'package:flutter/material.dart';

import '../../commons/filled_calendar_entry.dart';
import '../../utils/calendar_date_utils.dart';
import '../../utils/enums/weekday.dart';
import 'day_view_date.dart';
import 'line_painter.dart';

class CalendarDayView extends StatefulWidget {
  const CalendarDayView({
    required this.entries,
    required this.displayDate,
    this.dayMarkColor = Colors.blueAccent,
    this.hourSpace = 48,
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
  Map<CalendarEntry, double> entryDragPosition = {};
  Map<CalendarEntry, double> entryCurrentPositions = {};

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DayViewDate(
              displayDate: widget.displayDate,
              dayMarkColor: widget.dayMarkColor,
            ),
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
        entryDragPosition.putIfAbsent(
          e,
          () => 50,
        );
        return Positioned(
          top: entryDragPosition[e],
          child: GestureDetector(
            onVerticalDragStart: (details) => _dragStart(e, details),
            onVerticalDragUpdate: (details) => _dragUpdate(e, details),
            onVerticalDragEnd: (details) => _dragEnd(e, details),
            onVerticalDragCancel: () => _dragCancel(e),
            child: FilledCalendarEntry(
              padding: const EdgeInsets.all(8),
              entry: e,
              width: width,
            ),
          ),
        );
      },
    ).toList();
  }

  _dragStart(CalendarEntry entry, DragStartDetails details) {
    entryCurrentPositions.putIfAbsent(
      entry,
      () => entryDragPosition[entry]!,
    );
  }

  _dragUpdate(CalendarEntry entry, DragUpdateDetails details) {
    setState(() {
      entryDragPosition.update(
        entry,
        (value) => value += details.delta.dy,
      );
    });
  }

  _dragEnd(CalendarEntry entry, DragEndDetails details) {
    entryCurrentPositions.remove(entry);
  }

  _dragCancel(CalendarEntry entry) {
    setState(() {
      entryDragPosition.update(
        entry,
        (value) => value = entryCurrentPositions[entry]!,
      );
      entryCurrentPositions.remove(entry);
    });
  }
}
