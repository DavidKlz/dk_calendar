import 'package:flutter/material.dart';

import '../utils/calendar_date_utils.dart';
import '../utils/enums/weekday.dart';

class CalendarDayView extends StatefulWidget {
  const CalendarDayView({
    required this.displayDate,
    this.dayMarkColor = Colors.blueAccent,
    super.key,
  });

  final DateTime displayDate;
  final Color dayMarkColor;

  @override
  State<CalendarDayView> createState() => _CalendarDayViewState();
}

class _CalendarDayViewState extends State<CalendarDayView> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  Weekday.getAbbreviatedWeekday(widget.displayDate.weekday),
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.dayMarkColor,
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.dayMarkColor,
                      ),
                      height: 50,
                      width: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.5, vertical: 3),
                      child: Text(
                        "${widget.displayDate.day}",
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            SingleChildScrollView(
              child: Column(
                
              ),
            )
          ],
        );
      }
    );
  }
}
