import 'dart:ui';

import 'package:flutter/material.dart';

import '../data/calendar_entry.dart';
import '../utils/calendar_date_utils.dart';

class CalendarMonthView extends StatefulWidget {
  const CalendarMonthView({
    required this.entries,
    required this.displayDate,
    this.showCalendarWeek = false,
    this.padding = const EdgeInsets.all(8),
    this.entryPadding = const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
    this.dayMarkColor = Colors.blueAccent,
    super.key,
  });

  final Map<DateTime, List<CalendarEntry>> entries;
  final DateTime displayDate;
  final bool showCalendarWeek;
  final EdgeInsets padding;
  final EdgeInsets entryPadding;
  final Color dayMarkColor;

  @override
  State<CalendarMonthView> createState() => _CalendarMonthViewState();
}

class _CalendarMonthViewState extends State<CalendarMonthView> {
  List<DateTime> dates = [];
  List<int> calendarWeek = [];
  bool isDragging = false;
  Size colSize = const Size(0, 0);

  ({DateTime? date, CalendarEntry? entry}) draggedRecord =
      (date: null, entry: null);

  @override
  void initState() {
    super.initState();
    dates = CalendarDateUtils.getMonthDateTimesFor(widget.displayDate);
    if (dates.length % 7 != 0) {
      throw Exception(
          "Missing weekdays: ${dates.length} | First Date: ${dates[0].toIso8601String()} | Last Date: ${dates[dates.length - 1].toIso8601String()}");
    }
    var iterations = dates.length / 7;
    for (int i = 0; i < iterations; i++) {
      calendarWeek.add(CalendarDateUtils.getWeekNumber(dates[i + 7 * i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        colSize = Size(constraints.maxWidth / 7,
            constraints.maxHeight / (dates.length / 7));

        Map<int, TableColumnWidth> columnWidths = {
          0: const IntrinsicColumnWidth(),
        };

        for (int i = 1; i <= dates.length / 7; i++) {
          columnWidths.putIfAbsent(
            i,
            () => const FlexColumnWidth(),
          );
        }

        return MouseRegion(
          cursor:
              isDragging ? SystemMouseCursors.move : SystemMouseCursors.basic,
          child: Table(
            columnWidths: columnWidths,
            border: TableBorder.all(color: Colors.grey, width: 0.5),
            children: _createRows(),
          ),
        );
      },
    );
  }

  List<TableRow> _createRows() {
    List<TableRow> rows = [];

    for (int i = 0; i < dates.length / 7; i++) {
      Iterable<DateTime> take = dates.getRange(0 + 7 * i, 7 + 7 * i);

      List<Widget> children = [];

      children.add(
        TableCell(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
            ),
            height: colSize.height,
            padding: const EdgeInsets.all(8.0),
            margin: EdgeInsets.fromLTRB(0, (i == 0) ? 8 : 0, 0, (i * 7 == dates.length) ? 8 : 0),
            child: Text("${calendarWeek[i]}"),
          ),
        ),
      );

      children.addAll(take.map(
        (e) => TableCell(
          child: _createDragTarget(e, i == 0),
        ),
      ));

      rows.add(
        TableRow(
          children: children,
        ),
      );
    }
    return rows;
  }

  DragTarget<CalendarEntry> _createDragTarget(DateTime e, bool showDayString) {
    var target = DragTarget<CalendarEntry>(
      onAcceptWithDetails: (details) => _onAcceptEntry(e, details),
      onMove: (details) => _onMove(e, details),
      builder: (context, candidateData, rejectedData) => ClipRect(
        child: SizedOverflowBox(
          alignment: Alignment.topCenter,
          size: colSize,
          child: Padding(
            padding: widget.padding,
            child: Column(
              children: [
                if (showDayString) _addDayHeader(e),
                _createDayText(e),
                SizedBox(height: widget.padding.top / 2),
                _createEntries(e),
              ],
            ),
          ),
        ),
      ),
    );
    return target;
  }

  Widget _addDayHeader(DateTime date) {
    return Text(CalendarDateUtils.getWeekDayString(date.weekday));
  }

  Widget _createDayText(DateTime date) {
    var now = DateTime.now();
    if (date == DateTime(now.year, now.month, now.day)) {
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.dayMarkColor,
            ),
            height: 25,
            width: 25,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 3.75, vertical: 1.5),
            child: Text(
              "${date.day}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: [
          const SizedBox(
            height: 25,
          ),
          Text("${date.day}"),
        ],
      );
    }
  }

  Widget _createEntries(DateTime dateTime) {
    List<Draggable> draggableEntries = [];
    if (widget.entries[dateTime] != null) {
      for (var entry in widget.entries[dateTime]!) {
        draggableEntries.add(Draggable<CalendarEntry>(
          data: entry,
          onDragStarted: () => setState(() => isDragging = true),
          onDragEnd: (details) => _dragEnd(),
          onDragCompleted: _dragEnd,
          onDraggableCanceled: (velocity, offset) => _dragEnd(),
          dragAnchorStrategy: pointerDragAnchorStrategy,
          feedback: const SizedBox(),
          child: Container(
            padding: widget.entryPadding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: entry.color,
            ),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.name,
                  style: entry.textStyle,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Icon(
                    entry.trailingIcon,
                    color: entry.trailingIconColor,
                    size: 15,
                  ),
                ),
              ],
            ),
          ),
        ));
      }
    }
    if (draggedRecord.date != null &&
        draggedRecord.date!.isAtSameMomentAs(dateTime)) {
      draggableEntries.add(Draggable<CalendarEntry>(
        data: draggedRecord.entry,
        feedback: const SizedBox(),
        child: Container(
          padding: widget.entryPadding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: draggedRecord.entry!.color.withOpacity(0.5),
          ),
          width: double.infinity,
          child: Text(
            draggedRecord.entry!.name,
            style: draggedRecord.entry!.textStyle,
          ),
        ),
      ));
    }
    return Column(children: draggableEntries);
  }

  _dragEnd() {
    setState(() {
      draggedRecord = (date: null, entry: null);
      isDragging = false;
    });
  }

  _onAcceptEntry(DateTime dateTime, DragTargetDetails<CalendarEntry> details) {
    setState(() {
      widget.entries.values
          .where(
            (element) => element.contains(details.data),
          )
          .forEach(
            (element) => element.remove(details.data),
          );
      if (widget.entries.containsKey(dateTime)) {
        widget.entries.update(
          dateTime,
          (value) {
            value.add(details.data);
            return value;
          },
        );
      } else {
        widget.entries.putIfAbsent(dateTime, () => [details.data]);
      }
    });
  }

  _onMove(DateTime dateTime, DragTargetDetails<CalendarEntry> details) {
    setState(() {
      draggedRecord = (date: dateTime, entry: details.data);
    });
  }
}
