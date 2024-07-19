import 'package:flutter/material.dart';

import '../utils/calendar_date_utils.dart';
import '../utils/enums/calendar_view.dart';
import '../utils/enums/month.dart';

class CalendarHeader extends StatefulWidget {
  const CalendarHeader({
    required this.date,
    required this.view,
    required this.onLeftPressed,
    required this.onRightPressed,
    required this.onTodayPressed,
    required this.onSelectView,
    super.key,
  });

  final DateTime date;
  final CalendarView view;
  final VoidCallback onLeftPressed;
  final VoidCallback onRightPressed;
  final VoidCallback onTodayPressed;
  final Function(CalendarView? selectedView) onSelectView;

  @override
  State<CalendarHeader> createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<CalendarHeader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              OutlinedButton(
                onPressed: widget.onTodayPressed,
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                ),
                child: const Text("Today"),
              ),
              const SizedBox(width: 25),
              IconButton(
                  onPressed: widget.onLeftPressed,
                  icon: const Icon(Icons.chevron_left)),
              IconButton(
                  onPressed: widget.onRightPressed,
                  icon: const Icon(Icons.chevron_right)),
              const SizedBox(width: 25),
              Text(
                "${Month.getMonth(widget.date.month)} ${widget.date.year}",
                style: const TextStyle(fontSize: 23),
              ),
            ],
          ),
          DropdownMenu(
            dropdownMenuEntries: CalendarView.values
                .map(
                  (e) => DropdownMenuEntry(value: e, label: e.displayName),
                )
                .toList(),
            onSelected: (value) => widget.onSelectView.call(value),
            initialSelection: widget.view,
          ),
        ],
      ),
    );
  }
}
