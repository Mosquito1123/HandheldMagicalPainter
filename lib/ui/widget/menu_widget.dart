import 'package:flutter/material.dart';
import 'package:flutter_paint/ui/widget/dialog_color_picker.dart';
import 'package:flutter_paint/utility/event.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuWidget extends StatefulWidget {
  MenuWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  final colorAlert = ColorPickerAlert();
  final fillAlert = ColorPickerAlert();

  @override
  void initState() {
    super.initState();

    colorAlert.onSuccess = () {
      setState(() {});
      eventBus.fire(ChangeColorEvent(colorAlert.currentColor));
    };

    fillAlert.onSuccess = () {
      eventBus.fire(FillEvent(fillAlert.currentColor));
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            color: Colors.pink,
            icon: new Icon(
              FontAwesomeIcons.trashAlt,
            ),
            onPressed: () {
              eventBus.fire(ClearBoardEvent());
            },
          ),
          IconButton(
            color: colorAlert.currentColor,
            icon: new Icon(
              FontAwesomeIcons.palette,
            ),
            onPressed: () {
              colorAlert.show(context);
            },
          ),
          IconButton(
            color: Colors.pink,
            icon: new Icon(
              FontAwesomeIcons.fill,
            ),
            onPressed: () {
              fillAlert.show(context);
            },
          ),
          IconButton(
            color: Colors.pink,
            icon: new Icon(
              FontAwesomeIcons.exchangeAlt,
            ),
            onPressed: () {
              eventBus.fire(ChangeDrawModeEvent());
            },
          ),
          IconButton(
            color: Colors.pink,
            icon: new Icon(
              FontAwesomeIcons.fileExport,
            ),
            onPressed: () {
              eventBus.fire(ExportImageEvent());
            },
          ),
          IconButton(
            color: Colors.pink,
            icon: new Icon(
              FontAwesomeIcons.undo,
            ),
            onPressed: () {
              eventBus.fire(UndoEvent());
            },
          ),
          IconButton(
            color: Colors.pink,
            icon: new Icon(
              FontAwesomeIcons.redo,
            ),
            onPressed: () {
              eventBus.fire(RedoEvent());
            },
          ),
          IconButton(
            color: Colors.pink,
            icon: new Icon(
              FontAwesomeIcons.image,
            ),
            onPressed: () {
              eventBus.fire(ChangeBackgroundEvent());
            },
          ),
          IconButton(
            color: Colors.pink,
            icon: new Icon(
              FontAwesomeIcons.shareAlt,
            ),
            onPressed: () {
              eventBus.fire(ShareEvent());
            },
          ),
        ],
      ),
    );
  }
}
