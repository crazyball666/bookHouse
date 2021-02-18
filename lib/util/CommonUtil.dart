import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 通用工具类
class CommonUtil {
  static BuildContext rootContext;

  // ignore: close_sinks
  static StreamController logoutBroadcast = StreamController.broadcast();

  /// MaterialApp的Navigator key,用于路由跳转
  static final rootNavKey = new GlobalKey<NavigatorState>();

  /// 全局跳转
  static Future navigatorPush(Widget page) async {
    return rootNavKey.currentState.push(
      CupertinoPageRoute(builder: (BuildContext context) {
        return page;
      }),
    );
  }

  /// 全局跳转
  static Future navigatorPop(Widget page) async {
    return rootNavKey.currentState.push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Offset begin = Offset(0.0, 1.0);
          Offset end = Offset.zero;
          Animatable<Offset> tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: Curves.ease));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  /// 基本域名
  static String baseHost = "http://9de3cc3a7701.ngrok.io";

  static String imageHost = "$baseHost/cbh_file";
}
