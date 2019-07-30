import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_paint/data/path_histories.dart';
import 'package:flutter_paint/utility/common.dart';

class DrawingPainter extends CustomPainter {
  final PathHistories _histories;

  DrawingPainter({PathHistories histories}) : _histories = histories;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0.0, 0.0, size.width, size.height),
      _histories.backgroundPaint,
    );
    _histories.paths.forEach((history) {
      canvas.drawPoints(
        history.pointMode,
        history.offsets,
        history.paint,
      );
    });
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
