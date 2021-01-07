import 'package:flutter/material.dart';

class CommonUtil {
  static BuildContext rootContext;

  /// MaterialApp的Navigator key,用于路由跳转,其实就Navigator组件
  static final rootNavKey = new GlobalKey<NavigatorState>();
}
