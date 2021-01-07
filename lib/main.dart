import 'package:bookApp/pages/rootPage.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
  if (Platform.isAndroid) {
    //沉浸式状态栏
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  //竖版
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '城市书屋',
      debugShowCheckedModeBanner: false,
      navigatorKey: CommonUtil.rootNavKey,
      home: AppRootPage(),
    );
  }
}
