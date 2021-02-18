import 'package:flutter/material.dart';

class BookCommentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BookCommentPageState();
}

class _BookCommentPageState extends State<BookCommentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("图书评价"),
      ),
    );
  }
}
