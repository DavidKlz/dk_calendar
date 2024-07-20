import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  LinePainter({required this.space});

  final double space;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
        ..color = Colors.black
        ..strokeWidth = 0.1;

    for(var i = 0; i < 25; i++) {
      final dy = i * space;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}