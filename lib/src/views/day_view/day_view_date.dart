import 'package:flutter/material.dart';

import '../../utils/enums/weekday.dart';

class DayViewDate extends StatelessWidget {
  const DayViewDate({required this.displayDate, required this.dayMarkColor, super.key});

  final DateTime displayDate;
  final Color dayMarkColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          Weekday.getAbbreviatedWeekday(displayDate.weekday),
          style: TextStyle(
            fontSize: 12,
            color: dayMarkColor,
          ),
        ),
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dayMarkColor,
              ),
              height: 50,
              width: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.5, vertical: 3),
              child: Text(
                "${displayDate.day}",
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
