import 'package:flutter/material.dart';

class CalendarEntry {
  String name;
  Color color;
  TextStyle textStyle;
  DateTime? repeatInfo;
  IconData? trailingIcon;
  Color trailingIconColor;

  CalendarEntry({
    required this.name,
    this.color = Colors.blueAccent,
    this.textStyle = const TextStyle(color: Colors.white),
    this.repeatInfo,
    this.trailingIcon,
    this.trailingIconColor = Colors.white,
  });
}
