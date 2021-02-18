import 'package:bookApp/components/CacheImageView.dart';
import 'package:bookApp/components/LoadingView.dart';
import 'package:bookApp/models/BorrowBookItem.dart';
import 'package:bookApp/pages/BorrowAndReturnBook/BorrowAndReturnBookPage.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

class CurrentBorrowPage extends StatefulWidget {
  final List<Map> books;

  CurrentBorrowPage({this.books = const []});

  @override
  State<StatefulWidget> createState() => _CurrentBorrowPageState();
}

class _CurrentBorrowPageState extends State<CurrentBorrowPage> {
  String _formatTime(String timeString) {
    return timeString.substring(0, 10);
  }

  bool _loading = false;

  int _restDay(String dateString) {
    return DateTime.parse(dateString).difference(DateTime.now()).inDays;
  }

  /// 续借
  _renew() async {}

  /// 归还
  _return() async {
    CommonUtil.navigatorPush(
      BorrowAndReturnBookPage(
        type: PageType.PageTypeReturn,
        books: widget.books
            .where((e) => e["selected"] == true)
            .map(
              (e) => BorrowBookItem(
                recordId: e["id"],
                bookId: e["book_id"],
                name: e["book_name"],
                author: e["book_author"],
                image: e["book_image"],
                category: e["book_first_cate"],
                startTime: DateTime.parse(e["start_time"]),
                endTime: DateTime.parse(e["end_time"]),
              ),
            )
            .toList(),
      ),
    );
  }

  _onChange(bool value, int index) {
    setState(() {
      widget.books[index]["selected"] = value;
    });
  }

  _onSelectAll(bool value) {
    widget.books.forEach((book) {
      book["selected"] = value;
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.books.forEach((book) {
      book["selected"] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("当前借阅"),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 250.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Color(0xffcccccc), width: 8))),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontWeight: FontWeight.bold,
                        fontSize: 32.sp),
                    children: [
                      TextSpan(
                        text: "${widget.books.length}",
                        style: TextStyle(
                          fontSize: 60.sp,
                        ),
                      ),
                      TextSpan(text: "本"),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Checkbox(
                      value: widget.books
                              .indexWhere((book) => book["selected"] != true) <
                          0,
                      onChanged: _onSelectAll,
                      activeColor: Colors.blue,
                    ),
                    Text("全选"),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20.w, horizontal: 20.w),
                          child: Row(
                            children: [
                              Checkbox(
                                value: widget.books[index]["selected"] == true,
                                onChanged: (value) => _onChange(value, index),
                                activeColor: Colors.blue,
                              ),
                              Container(
                                height: 300.w,
                                width: 200.w,
                                margin: EdgeInsets.only(right: 30.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.w)),
                                clipBehavior: Clip.hardEdge,
                                child: CacheImageView(
                                  url:
                                      "${CommonUtil.imageHost}${widget.books[index]["book_image"]}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 300.w,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        child: Text(
                                          "${widget.books[index]["book_name"]}",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 36.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          "${_formatTime(widget.books[index]["start_time"])} 至 ${_formatTime(widget.books[index]["end_time"])}",
                                          style: TextStyle(
                                            fontSize: 24.sp,
                                            color: Color(0xff666666),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          "${widget.books[index]["book_author"]}",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 24.sp,
                                            color: Color(0xff666666),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          "${widget.books[index]["book_first_cate"]}",
                                          style: TextStyle(
                                            fontSize: 24.sp,
                                            color: Color(0xff666666),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          child: Text(
                            "剩余${_restDay(widget.books[index]["end_time"])}天",
                            style: TextStyle(
                              fontSize: 22.sp,
                              color: Colors.orange,
                            ),
                          ),
                          right: 20.w,
                          bottom: 20.w,
                        )
                      ],
                    );
                  },
                  itemCount: widget.books.length,
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 30.w, right: 30.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RaisedButton(
                      onPressed: _renew,
                      child: Text("续借"),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                    SizedBox(
                      width: 30.w,
                    ),
                    RaisedButton(
                      onPressed: widget.books
                              .where((e) => e["selected"] == true)
                              .isNotEmpty
                          ? _return
                          : null,
                      child: Text(
                        "归还",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                    ),
                  ],
                ),
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
}
