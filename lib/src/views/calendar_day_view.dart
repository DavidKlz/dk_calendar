import 'package:flutter/material.dart';

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
    return Column(
      children: [
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
    );
  }
}
