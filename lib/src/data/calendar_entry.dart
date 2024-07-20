import 'package:flutter/material.dart';

class CalendarEntry {
  String name;
  DateTime startDate;
  DateTime? endDate;
  Color color;
  TextStyle textStyle;
  DateTime? repeatInfo;
  IconData? trailingIcon;
  Color trailingIconColor;

  CalendarEntry({
    required this.name,
    required this.startDate,
    this.endDate,
    this.color = Colors.blueAccent,
    this.textStyle = const TextStyle(color: Colors.white),
    this.repeatInfo,
    this.trailingIcon,
    this.trailingIconColor = Colors.white,
  });
}
