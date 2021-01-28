import 'package:bookApp/models/Book.dart';
import 'package:bookApp/pages/MyRead/BorrowBookListView.dart';
import 'package:bookApp/pages/MyRead/OverviewView.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

class MyReadPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyReadPageState();
}

class _MyReadPageState extends State<MyReadPage> {
  List<Book> _bookList = [
    Book.mock(),
    Book.mock(),
    Book.mock(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Color(0xffaaaaaa),
        elevation: 0,
      ),
      body: Container(
        // color: Color(0xffaaaaaa),
        child: ListView(
          children: [
            Container(
              color: Colors.red,
              margin: EdgeInsets.only(bottom: 160.w),
              child: OverviewView(),
            ),
            BorrowBoolListView(
              title: "当前借阅",
              books: _bookList,
            ),
            BorrowBoolListView(
              title: "历史借阅",
              books: _bookList,
            ),
          ],
        ),
      ),
    );
  }
}
