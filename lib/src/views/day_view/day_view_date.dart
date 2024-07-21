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
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dayMarkColor,
          ),
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
          height: 50,
          width: 50,
          alignment: Alignment.center,
          child: Text(
            "${displayDate.day}",
            style: const TextStyle(
              fontSize: 28,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
