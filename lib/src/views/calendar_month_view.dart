import 'dart:ui';

import 'package:flutter/material.dart';

import '../data/calendar_entry.dart';
import '../utils/calendar_date_utils.dart';

class CalendarMonthView extends StatefulWidget {
  const CalendarMonthView({
    this.showCalendarWeek = false,
    this.padding = const EdgeInsets.all(8),
    this.entryPadding = const EdgeInsets.all(4),
    this.dayMarkColor = Colors.blueAccent,
    super.key,
  });

  final bool showCalendarWeek;
  final EdgeInsets padding;
  final EdgeInsets entryPadding;
  final Color dayMarkColor;

  @override
  State<CalendarMonthView> createState() => _CalendarMonthViewState();
}

class _CalendarMonthViewState extends State<CalendarMonthView> {
  bool isDragging = false;
  Map<DateTime, List<CalendarEntry>> entries = {};

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    entries.putIfAbsent(DateTime(now.year, now.month, now.day),
        () => [CalendarEntry(name: "Test")]);
    return LayoutBuilder(
      builder: (_, constraints) => MouseRegion(
        cursor: isDragging ? SystemMouseCursors.move : SystemMouseCursors.basic,
        child: Table(
          border: TableBorder.all(color: Colors.grey, width: 0.5),
          children: _createRows(constraints),
        ),
      ),
    );
  }

  List<TableRow> _createRows(BoxConstraints constraints) {
    List<DateTime> month =
        CalendarDateUtils.getMonthDateTimesFor(DateTime.now());
    final height = constraints.maxHeight / (month.length / 7);
    List<TableRow> rows = [];
    while (month.isNotEmpty) {
      Iterable<DateTime> take = month.take(7);

      rows.add(
        TableRow(
          children: take
              .map(
                (e) => TableCell(
                  child: _createDragTarget(e, height),
                ),
              )
              .toList(),
        ),
      );

      month.removeRange(0, 7);
    }
    return rows;
  }

  DragTarget<CalendarEntry> _createDragTarget(DateTime e, double height) {
    var target = DragTarget<CalendarEntry>(
      onAcceptWithDetails: (details) => _onAcceptEntry(e, details),
      onMove: (details) => _onMove(e, details),
      onLeave: (data) => _onLeave(e, data),
      builder: (context, candidateData, rejectedData) => SizedBox(
        height: height,
        child: Padding(
          padding: widget.padding,
          child: Column(
            children: [
              _createDayText(e),
              SizedBox(height: widget.padding.top / 2),
              _createEntries(e),
            ],
          ),
        ),
      ),
    );
    return target;
  }

  Widget _createDayText(DateTime date) {
    var now = DateTime.now();
    if (date == DateTime(now.year, now.month, now.day)) {
      return SizedBox(
        width: 28,
        height: 28,
        child: ClipOval(
          child: Container(
            color: widget.dayMarkColor,
            alignment: Alignment.center,
            child: Text(
              "${date.day}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      );
    } else {
      return Text("${date.day}");
    }
  }

  Widget _createEntries(DateTime dateTime) {
    List<Draggable> draggableEntries = [];
    if (entries[dateTime] != null) {
      for (var entry in entries[dateTime]!) {
        draggableEntries.add(Draggable<CalendarEntry>(
          data: entry,
          onDragStarted: () => setState(() => isDragging = true),
          onDragEnd: (details) => setState(() => isDragging = false),
          onDragCompleted: () => setState(() => isDragging = false),
          onDraggableCanceled: (velocity, offset) =>
              setState(() => isDragging = false),
          dragAnchorStrategy: pointerDragAnchorStrategy,
          feedback: SizedBox(),
          child: Container(
            padding: widget.entryPadding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.blueAccent,
            ),
            width: double.infinity,
            child: Text(entry.name),
          ),
        ));
      }
    }
    return Column(children: draggableEntries);
  }

  void _onAcceptEntry(
      DateTime dateTime, DragTargetDetails<CalendarEntry> details) {
    setState(() {
      entries.values
          .where(
            (element) => element.contains(details.data),
          )
          .forEach(
            (element) => element.remove(details.data),
          );
      if (entries.containsKey(dateTime)) {
        entries.update(
          dateTime,
          (value) {
            value.add(details.data);
            return value;
          },
        );
      } else {
        entries.putIfAbsent(dateTime, () => [details.data]);
      }
    });
  }

  _onMove(DateTime dateTime, DragTargetDetails<CalendarEntry> details) {
    setState(() {
      if (entries.containsKey(dateTime) &&
          !entries[dateTime]!.contains(details.data)) {
        entries.update(
          dateTime,
          (value) {
            value.add(details.data);
            return value;
          },
        );
      } else {
        entries.putIfAbsent(dateTime, () => [details.data]);
      }
    });
  }

  _onLeave(DateTime e, CalendarEntry? data) {
    setState(() => entries.update(
          e,
          (value) {
            value.remove(data);
            return value;
          },
        ));
  }
}
