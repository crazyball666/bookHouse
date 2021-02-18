import 'dart:math';

import 'package:bookApp/components/LoadingView.dart';
import 'package:bookApp/models/Book.dart';
import 'package:bookApp/network/ApiRequest.dart';
import 'package:bookApp/pages/CurrentBorrow/CurrentBorrowPage.dart';
import 'package:bookApp/pages/HistoryBorrow/HistoryBorrowPage.dart';
import 'package:bookApp/pages/MyRead/BorrowBookListView.dart';
import 'package:bookApp/pages/MyRead/OverviewView.dart';
import 'package:bookApp/pages/ViolationBorrow/ViolationBorrowPage.dart';
import 'package:bookApp/provider/UserProvider.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';
import 'package:provider/provider.dart';

class MyReadPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyReadPageState();
}

class _MyReadPageState extends State<MyReadPage>
    with AutomaticKeepAliveClientMixin {
  bool _loading = false;

  /// 当前借阅
  List<Map> _currentBooks = [];

  /// 历史借阅
  List<Map> _historyBooks = [];

  /// 违规借阅
  List<Map> _violationBooks = [];

  /// 获取数据
  _fetchData() async {
    setState(() {
      _loading = true;
    });
    List<Future> futures = [];
    int uid = Provider.of<UserProvider>(context, listen: false).user.id;
    Future current = ApiRequest()
        .getBookBorrowList(uid: uid, type: BorrowListType.BorrowListTypeNow)
        .then((books) {
      setState(() {
        _currentBooks = books;
      });
    });
    futures.add(current);

    Future history = ApiRequest()
        .getBookBorrowList(uid: uid, type: BorrowListType.BorrowListTypeHistory)
        .then((books) {
      setState(() {
        _historyBooks = books;
      });
    });
    futures.add(history);

    Future violation = ApiRequest()
        .getBookBorrowList(
            uid: uid, type: BorrowListType.BorrowListTypeViolation)
        .then((books) {
      setState(() {
        _violationBooks = books;
      });
    });
    futures.add(violation);

    await Future.wait(futures).then((_) {
      setState(() {
        _loading = false;
      });
    }).catchError((err) {
      print("【Error】$err");
    });
  }

  _goCurrentBorrowPage() {
    CommonUtil.navigatorPush(CurrentBorrowPage(
      books: _currentBooks,
    ));
  }

  _goHistoryBorrowPage() {
    CommonUtil.navigatorPush(HistoryBorrowPage(
      books: _historyBooks,
    ));
  }

  _goViolationBorrowPage() {
    CommonUtil.navigatorPush(ViolationBorrowPage(
      books: _violationBooks,
    ));
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Color(0xffaaaaaa),
        elevation: 0,
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                color: Colors.red,
                margin: EdgeInsets.only(bottom: 160.w),
                child: OverviewView(
                  items: [
                    OverviewItem(
                      name: "当前借阅",
                      data: _currentBooks.length,
                      unit: "本",
                      onTap: _goCurrentBorrowPage,
                    ),
                    OverviewItem(
                      name: "阅读数量",
                      data: _historyBooks.length,
                      unit: "本",
                      onTap: _goHistoryBorrowPage,
                    ),
                    OverviewItem(
                      name: "违规记录",
                      data: _violationBooks.length,
                      unit: "次",
                      onTap: _goViolationBorrowPage,
                    ),
                  ],
                ),
              ),
              BorrowBoolListView(
                title: "当前借阅",
                books: _currentBooks.sublist(0, min(3, _currentBooks.length)),
                onTap: _goCurrentBorrowPage,
              ),
              BorrowBoolListView(
                title: "历史借阅",
                books: _historyBooks.sublist(0, min(3, _historyBooks.length)),
                onTap: _goHistoryBorrowPage,
              ),
            ],
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _loading ? LoadingView() : Container(),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
