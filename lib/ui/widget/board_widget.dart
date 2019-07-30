import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_paint/data/path_histories.dart';
import 'package:flutter_paint/ui/widget/drawing_painter.dart';
import 'package:flutter_paint/utility/bus_state.dart';
import 'package:flutter_paint/utility/common.dart';
import 'package:flutter_paint/utility/event.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share/share.dart';

class BoardWdiget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BoardWdigetState();
}

class _BoardWdigetState extends BusState<BoardWdiget> {
  double _strokeWidth = 3.0;
  Color _color = Colors.red;
  bool _isEraserMode = false;
  PointMode _pointMode = PointMode.polygon;
  ImageProvider _backgroundImage;

  final _histories = PathHistories();
  final _boardGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _setupEvent();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _boardGlobalKey,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: _getBackgroundImage(),
          ),
        ),
        child: GestureDetector(
          onPanUpdate: _onPanUpdate,
          onPanStart: _onPanStart,
          onPanEnd: _onPanEnd,
          child: ClipRect(
            child: CustomPaint(
              size: Size.infinite,
              painter: DrawingPainter(histories: _histories),
            ),
          ),
        ),
      ),
    );
  }

  _setupEvent() {
    eventBusSubscription = eventBus.on<AppEvent>().listen((event) {
      if (event is ClearBoardEvent) {
        _clear();
      } else if (event is ChangeColorEvent) {
        _changeColor(event.color);
      } else if (event is ExportImageEvent) {
        _takeScreenshot();
      } else if (event is UndoEvent) {
        _undo();
      } else if (event is RedoEvent) {
        _redo();
      } else if (event is ChangeDrawModeEvent) {
        _changeDrawingMode();
      } else if (event is EraserEvent) {
        _toggleBlendMode();
      } else if (event is ShareEvent) {
        _share();
      } else if (event is ChangeBackgroundEvent) {
        _pickImage();
      } else if (event is FillEvent) {
        _changeBackgroundColor(event.color);
      }
    });
  }

  _onPanStart(DragStartDetails details) {
    setState(() {
      final renderBox = context.findRenderObject() as RenderBox;
      final point = renderBox.globalToLocal(details.globalPosition);

      _histories.startSession(_createPaint(), _pointMode);
      _histories.addPoint(point);
    });
  }

  _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      final renderBox = context.findRenderObject() as RenderBox;
      final point = renderBox.globalToLocal(details.globalPosition);
      _histories.addPoint(point);
    });
  }

  _onPanEnd(DragEndDetails details) {
    setState(() {
      _histories.finishSession();
    });
  }

  Paint _createPaint() {
    final color = _isEraserMode ? Colors.transparent : _color;
    final blendMode = _isEraserMode ? BlendMode.clear : BlendMode.srcOver;
    return Paint()
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..blendMode = blendMode
      ..color = color
      ..strokeWidth = _strokeWidth;
  }

  ImageProvider _getBackgroundImage() {
    if (_backgroundImage != null) {
      return _backgroundImage;
    }
    return AssetImage(
      pathOfImages('background.png'),
    );
  }

  _clear() {
    setState(() {
      _backgroundImage = null;
      if (_histories.paths.isEmpty) {
        return;
      }
      _histories.clear();
    });
  }

  _changeColor(Color color) {
    setState(() {
      _color = color.withOpacity(_color.opacity);
    });
  }

  _changeStrokeWidth(double strokeWidth) {
    setState(() {
      _strokeWidth = strokeWidth;
    });
  }

  _changeOpacity(double opacity) {
    setState(() {
      _color = _color.withOpacity(opacity);
    });
  }

  _undo() {
    setState(() {
      _histories.undo();
    });
  }

  _redo() {
    setState(() {
      _histories.redo();
    });
  }

  _changeDrawingMode() {
    setState(() {
      if (_pointMode == PointMode.polygon) {
        _pointMode = PointMode.lines;
      } else if (_pointMode == PointMode.lines) {
        _pointMode = PointMode.points;
      } else {
        _pointMode = PointMode.polygon;
      }
    });
  }

  _takeScreenshot() {
    if (_histories.paths.isEmpty) {
      return;
    }

    takeScreenShot(_boardGlobalKey);
  }

  _changeBackgroundColor(Color color) {
    setState(() {
      _histories.changeBackgroundColor(color);
    });
  }

  // I don't know why clear mode not working
  _toggleBlendMode() {
    _isEraserMode = !_isEraserMode;
  }

  Future _pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    setState(() {
      _backgroundImage = FileImage(image);
    });
  }

  _share() {
    Share.share('Flutter Paint');
  }
}
