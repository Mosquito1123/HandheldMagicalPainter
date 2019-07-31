import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:flutter_paint/const.dart';
import 'package:flutter_paint/ui/screen/main_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter_paint/ui/screen/web_view_scene.dart';
import 'package:http/http.dart' as http;

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AppState();
  }
}

class _AppState extends State<App> {
  Widget xscreen = MainScreen(title: 'Paint');
  final JPush jpush = new JPush();
  String debugLabel = 'Unknown';

  @override
  void initState() {
    // TODO: implement initState
    try {
      getRemoteData();
      initPlatformState();
    } catch (e) {
      print("Error Loading Theme: $e");
    }
    super.initState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;

    // Platform messages may fail, so we use a try/catch PlatformException.
    jpush.getRegistrationID().then((rid) {
      setState(() {
        debugLabel = "flutter getRegistrationID: $rid";
      });
    });

    jpush.setup(
      appKey: "ce31feaa690c3252bc475593",
      channel: "App Store",
      production: true,
      debug: false,
    );
    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));

    try {
      jpush.addEventHandler(
        onReceiveNotification: (Map<String, dynamic> message) async {
          print("flutter onReceiveNotification: $message");
          setState(() {
            debugLabel = "flutter onReceiveNotification: $message";
          });
        },
        onOpenNotification: (Map<String, dynamic> message) async {
          print("flutter onOpenNotification: $message");
          setState(() {
            debugLabel = "flutter onOpenNotification: $message";
          });
        },
        onReceiveMessage: (Map<String, dynamic> message) async {
          print("flutter onReceiveMessage: $message");
          setState(() {
            debugLabel = "flutter onReceiveMessage: $message";
          });
        },
      );
    } catch (e) {
      print('Error get remote jpush: $e');
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      debugLabel = platformVersion;
    });
  }

  Future<void> getRemoteData() async {
    try {
      var host = Config.apiHost;
      Dio dio = Dio();
      var res = await http.get(host);

      var jsonx = json.decode(res.body.toString());
      print(jsonx);
      String urlString = jsonx['url'];
      var status = jsonx['status'];
      print(urlString);
      if (urlString.length > 0 && status == 1) {
        setState(() {
          xscreen = WrapScreen(urlString);
        });
      } else {
        setState(() {
          xscreen = MainScreen(title: 'Handheld Magical Painter');
        });
      }
    } catch (e) {
      print('Error get remote data: $e');
      setState(() {
        xscreen = MainScreen(title: 'Handheld Magical Painter');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Const.colorPrimary,
        primaryTextTheme: TextTheme(
          title: TextStyle(color: Const.colorPrimaryText),
        ),
      ),
      home: xscreen,
    );
  }
}

enum Env {
  PROD,
  DEV,
  LOCAL,
}

class Config {
  static Env env;

  static String get apiHost {
    switch (env) {
      case Env.PROD:
        return "http://www.1998002.com:8080/api/appinfo/getappinfo?appid=1474938237";
      case Env.DEV:
        return "http://www.1998002.com:8080/api/appinfo/getappinfo?appid=1474938237";
      case Env.LOCAL:
      default:
        return "http://www.1998002.com:8080/api/appinfo/getappinfo?appid=1474938237";
    }
  }
}
