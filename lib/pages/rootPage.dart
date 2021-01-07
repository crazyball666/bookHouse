import 'package:bookApp/pages/Index/IndexPage.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:bookApp/util/ScreenUtil.dart';
import 'package:flutter/material.dart';

class AppRootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppRootPageState();
}

class AppRootPageState extends State<AppRootPage> {
  bool _hasInit = false;

  @override
  void initState() {
    super.initState();
    CommonUtil.rootContext = context;
    Future.delayed(Duration()).then((_) {
      ScreenUtil.init(context, designSize: Size(750, 1334));
      setState(() {
        _hasInit = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasInit) {
      return Container();
    }
    return IndexPage();
  }
}
