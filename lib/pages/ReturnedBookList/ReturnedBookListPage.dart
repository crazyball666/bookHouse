import 'package:bookApp/components/CacheImageView.dart';
import 'package:bookApp/components/LoadingView.dart';
import 'package:bookApp/network/ApiRequest.dart';
import 'package:bookApp/pages/BookComment/BookCommentPage.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

class ReturnedBookListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ReturnedBookListPageState();
}

class _ReturnedBookListPageState extends State<ReturnedBookListPage> {
  bool _loading = false;
  List<Map> _books = [];

  String _formatTime(String timeString) {
    return timeString.substring(0, 10);
  }

  _goComment(int index) async {
    await CommonUtil.navigatorPush(BookCommentPage(
      id: _books[index]["comment_id"],
      bookId: _books[index]["book_id"],
      content: _books[index]["comment_content"],
      score: _books[index]["comment_score"],
    ));
    setState(() {});
  }

  /// 列表项
  Widget _itemBuilder(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.w),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: 300.w,
                width: 200.w,
                margin: EdgeInsets.only(right: 30.w),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10.w)),
                clipBehavior: Clip.hardEdge,
                child: CacheImageView(
                  url: "${CommonUtil.imageHost}${_books[index]["book_image"]}",
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                  height: 300.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Text(
                          _books[index]["book_name"],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "${_formatTime(_books[index]["start_time"])} 至 ${_formatTime(_books[index]["return_time"])}",
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: Color(0xff666666),
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "作者：${_books[index]["book_author"]}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: Color(0xff666666),
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "分类：${_books[index]["book_first_cate"]}",
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
          Positioned(
            bottom: 20.w,
            right: 0,
            child: InkWell(
              splashColor: Color(0xff999999),
              onTap: () => _goComment(index),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.w),
                alignment: Alignment.center,
                width: 140.w,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff999999)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  _books[index]["comment_id"] > 0 ? "查看评价" : "评价",
                  style: TextStyle(fontSize: 22.sp, color: Color(0xff999999)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 获取数据
  _fetchData() async {
    setState(() {
      _loading = true;
    });
    try {
      _books = await ApiRequest().getReturnedBookList();
    } catch (err) {
      print("$err");
    }
    setState(() {
      _loading = false;
    });
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
        centerTitle: true,
        title: Text("图书评价"),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.w),
            child: ListView.builder(
              itemBuilder: _itemBuilder,
              itemCount: _books.length,
            ),
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
