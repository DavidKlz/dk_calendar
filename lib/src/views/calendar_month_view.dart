import 'dart:ui';

import 'package:flutter/material.dart';

import '../data/calendar_entry.dart';
import '../utils/calendar_date_utils.dart';
import '../utils/enums/weekday.dart';
import 'widgets/filled_calendar_entry.dart';

class CalendarMonthView extends StatefulWidget {
  const CalendarMonthView({
    required this.entries,
    required this.displayDate,
    this.showCalendarWeek = false,
    this.showDays = true,
    this.padding = const EdgeInsets.all(8),
    this.entryPadding = const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
    this.dayMarkColor = Colors.blueAccent,
    this.entryBuilder,
    this.dropIndicatorBuilder,
    super.key,
  });

  final Map<DateTime, List<CalendarEntry>> entries;
  final DateTime displayDate;
  final bool showCalendarWeek;
  final bool showDays;
  final EdgeInsets padding;
  final EdgeInsets entryPadding;
  final Color dayMarkColor;
  // TODO: Make the entries fully configurable
  final Widget Function(CalendarEntry entry)? entryBuilder;
  final Widget Function(CalendarEntry entry)? dropIndicatorBuilder;


  @override
  State<CalendarMonthView> createState() => _CalendarMonthViewState();
}

class _CalendarMonthViewState extends State<CalendarMonthView> {
  bool isDragging = false;
  Size colSize = const Size(0, 0);

  ({DateTime? date, CalendarEntry? entry}) draggedRecord =
      (date: null, entry: null);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        var dates = CalendarDateUtils.getMonthDateTimesFor(widget.displayDate);

        colSize = Size(
          constraints.maxWidth / 7,
          constraints.maxHeight / (dates.length / 7),
        );

        // TODO: Add Keyboard Listener to cancel drag via ESC
        return MouseRegion(
          cursor:
              isDragging ? SystemMouseCursors.move : SystemMouseCursors.basic,
          child: Table(
            columnWidths: const {0: IntrinsicColumnWidth()},
            border: TableBorder.all(color: Colors.grey, width: 0.5),
            children: _createRows(dates),
          ),
        );
      },
    );
  }

  List<TableRow> _createRows(List<DateTime> dates) {
    List<TableRow> rows = [];

    for (int i = 0; i < dates.length / 7; i++) {
      Iterable<DateTime> take = dates.getRange(0 + 7 * i, 7 + 7 * i);
      List<Widget> children = [];

      if(widget.showCalendarWeek) {
        var weekNumber = CalendarDateUtils.getWeekNumber(take.first);
        children.add(
          TableCell(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
              ),
              height: colSize.height,
              padding: const EdgeInsets.all(8.0),
              child: Text("$weekNumber"),
            ),
          ),
        );
      }

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

  DragTarget<CalendarEntry> _createDragTarget(DateTime e, bool inFirstRow) {
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
                if (inFirstRow && widget.showDays) _addDayHeader(e),
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
    return Text(Weekday.getAbbreviatedWeekday(date.weekday));
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
    // TODO: Make the entries fully configurable
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
          childWhenDragging: FilledCalendarEntry(entry: entry, padding: widget.entryPadding, opacity: 0.5,),
          child: FilledCalendarEntry(entry: entry, padding: widget.entryPadding,),
        ));
      }
    }
    if (draggedRecord.date != null &&
        draggedRecord.date!.isAtSameMomentAs(dateTime)) {
      draggableEntries.add(Draggable<CalendarEntry>(
        data: draggedRecord.entry,
        feedback: const SizedBox(),
        child: FilledCalendarEntry(entry: draggedRecord.entry!, padding: widget.entryPadding, opacity: 0.5,),
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
