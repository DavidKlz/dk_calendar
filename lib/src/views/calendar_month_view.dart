import 'package:flutter/material.dart';

class CalendarMonthView extends StatelessWidget {
  const CalendarMonthView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: DateTime.daysPerWeek,
      semanticChildCount: 35,
      scrollDirection: Axis.horizontal,
    );
  }
}
