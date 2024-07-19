import 'package:flutter/material.dart';

import '../../data/calendar_entry.dart';

class FilledCalendarEntry extends StatelessWidget {
  const FilledCalendarEntry({
    required this.entry,
    required this.padding,
    this.opacity = 1,
    super.key,
  });

  final CalendarEntry entry;
  final EdgeInsets padding;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: entry.color.withOpacity(opacity),
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            entry.name,
            style: entry.textStyle,
          ),
          if (entry.trailingIcon != null)
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
    );
  }
}
