import 'package:flutter/material.dart';

import '../utils/calendar_date_utils.dart';

class CalendarMonthView extends StatefulWidget {
  const CalendarMonthView({
    this.showCalendarWeek = false,
    this.padding = const EdgeInsets.all(8),
    this.dayMarkColor = Colors.blueAccent,
    super.key,
  });

  final bool showCalendarWeek;
  final EdgeInsets padding;
  final Color dayMarkColor;

  @override
  State<CalendarMonthView> createState() => _CalendarMonthViewState();
}

class _CalendarMonthViewState extends State<CalendarMonthView> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => Table(
        border: TableBorder.all(color: Colors.grey, width: 0.5),
        children: _createRows(constraints),
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
                  child: SizedBox(
                    height: height,
                    child: Padding(
                      padding: widget.padding,
                      child: Column(
                        children: [
                          _createDayText(e),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );

      month.removeRange(0, 7);
    }
    return rows;
  }

  Widget _createDayText(DateTime date) {
    var today = DateTime.now();
    if (date.day == today.day && date.month == today.month && date.year == today.year) {
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
}
