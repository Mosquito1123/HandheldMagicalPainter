import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

EventBus eventBus = EventBus();

abstract class AppEvent {}

class ClearBoardEvent implements AppEvent {}

class ChangeColorEvent implements AppEvent {
  final Color color;

  ChangeColorEvent(this.color);
}

class ExportImageEvent implements AppEvent {}

class UndoEvent implements AppEvent {}

class RedoEvent implements AppEvent {}

class ChangeDrawModeEvent implements AppEvent {}

class EraserEvent implements AppEvent {}

class ShareEvent implements AppEvent {}

class ChangeBackgroundEvent implements AppEvent {}

class FillEvent implements AppEvent {
  final Color color;

  FillEvent(this.color);
}
