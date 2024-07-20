import 'package:dk_calendar/dk_calendar.dart';
import 'package:flutter/material.dart';

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
  Map<CalendarEntry, double> entryDragPosition = {};
  Map<CalendarEntry, double> entryCurrentPositions = {};

  double draggedItemPosition = 0;

  double quarterHourSpace = 0;

  @override
  Widget build(BuildContext context) {
    quarterHourSpace = widget.hourSpace / 4;
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
        if (e.endDate != null) {
          entryDragPosition.putIfAbsent(
            e,
            () =>
                widget.hourSpace *
                ((e.endDate!.hour * 60 + e.endDate!.minute) / 60),
          );
        } else {
          // TODO: all day event
        }
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
              showTime: true,
              hourSpace: widget.hourSpace,
            ),
          ),
        );
      },
    ).toList();
  }

  _dragStart(CalendarEntry entry, DragStartDetails details) {
    draggedItemPosition = entryDragPosition[entry]!;
    entryCurrentPositions.putIfAbsent(
      entry,
      () => entryDragPosition[entry]!,
    );
  }

  _dragUpdate(CalendarEntry entry, DragUpdateDetails details) {
    setState(() {
      entryDragPosition.update(
        entry,
        (value) {
          draggedItemPosition = draggedItemPosition + details.delta.dy;
          return _getClosesSnappingPoint();
        },
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
        (value) => value = entryCurrentPositions[entry] ?? value,
      );
      entryCurrentPositions.remove(entry);
    });
  }

  double _getClosesSnappingPoint() {
    return quarterHourSpace * (draggedItemPosition / quarterHourSpace).round();
  }
}
