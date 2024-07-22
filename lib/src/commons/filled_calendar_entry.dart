import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/calendar_entry.dart';

class FilledCalendarEntry extends StatelessWidget {
  const FilledCalendarEntry({
    required this.entry,
    required this.padding,
    required this.width,
    this.hourSpace,
    this.opacity = 1,
    this.showTime = false,
    super.key,
  });

  final CalendarEntry entry;
  final EdgeInsets padding;
  final double opacity;
  final double width;
  final double? hourSpace;
  final bool showTime;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.fromLTRB(padding.left, _getHorizontalPadding(),
            padding.right, _getHorizontalPadding()),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: entry.color.withOpacity(opacity),
        ),
        width: width,
        height: (hourSpace != null) ? _calculateHeight() : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              direction: Axis.vertical,
              runSpacing: 8,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    entry.name,
                    style: entry.textStyle,
                  ),
                ),
                if (showTime)
                  FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "${DateFormat('HH:mm').format(entry.startDate)}${(entry.endDate != null) ? " - ${DateFormat('HH:mm').format(entry.endDate!)}" : ""}",
                        style: entry.textStyle,
                      )),
              ],
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
      ),
    );
  }

  double _getHorizontalPadding() {
    if (hourSpace == null) {
      return 2;
    } else {
      if (_calculateHeight() > (hourSpace! / 2)) {
        return 2;
      } else {
        return 0;
      }
    }
  }

  double _calculateHeight() {
    return (entry.endDate != null)
        ? (hourSpace! / 60) * entry.endDate!.difference(entry.startDate).inMinutes
        : hourSpace! / 4;
  }
}
