import 'dart:ui';

import 'package:flutter/material.dart';

class PathHistory {
  final Paint paint;
  final offsets = List<Offset>();
  final PointMode pointMode;
  PathHistory({this.paint, this.pointMode});
}

class PathHistories {
  final _paths = List<PathHistory>();

  final _backupPaths = List<PathHistory>();

  final _backgroundPaint = Paint()..color = Colors.transparent;

  List<PathHistory> get paths => _paths;

  Paint get backgroundPaint => _backgroundPaint;

  startSession(Paint paint, PointMode pointMode) {
    _paths.add(PathHistory(paint: paint, pointMode: pointMode));

    _backupPaths.clear();
  }

  addPoint(Offset point) {
    _paths.last.offsets.add(point);
  }

  finishSession() {
    if (_paths.last.offsets.length == 1) {
      _paths.last.offsets.add(_paths.last.offsets.first);
    }
  }

  clear() {
    _paths.clear();
  }

  undo() {
    if (paths.isEmpty) {
      return;
    }

    final last = paths.removeLast();
    _backupPaths.add(last);
  }

  redo() {
    if (_backupPaths.isEmpty) {
      return;
    }

    final last = _backupPaths.removeLast();
    _paths.add(last);
  }

  changeBackgroundColor(Color color) {
    _backgroundPaint.color = color;
  }
}
