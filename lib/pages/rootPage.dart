import 'package:flutter/material.dart';

class AppRootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppRootPageState();
}

class AppRootPageState extends State<AppRootPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("book app"),
      ),
    );
  }
}
