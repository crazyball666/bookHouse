import 'package:bookApp/components/CacheImageView.dart';
import 'package:bookApp/components/LoadingView.dart';
import 'package:bookApp/models/BorrowBookItem.dart';
import 'package:bookApp/models/BorrowCarBook.dart';
import 'package:bookApp/network/ApiRequest.dart';
import 'package:bookApp/pages/BorrowAndReturnBook/BorrowAndReturnBookPage.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

/// 借阅车页面
class BorrowCarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BorrowCarPageState();
}

class _BorrowCarPageState extends State<BorrowCarPage> {
  bool _loading = false;
  List<BorrowCarBook> _books = [];

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
                  url: "${CommonUtil.imageHost}${_books[index].bookImage}",
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
                          _books[index].bookName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          _books[index].bookAuthor ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: Color(0xff666666),
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "${_books[index]?.bookFirstCate}",
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: Color(0xff666666),
                          ),
                        ),
                      ),
                      // Container(
                      //   child: Text(
                      //     "${_books[index]?.bookPlace ?? ""}",
                      //     style: TextStyle(
                      //       fontSize: 24.sp,
                      //       color: Color(0xff666666),
                      //     ),
                      //   ),
                      // ),
                      Container(
                        child: Text(
                          "馆藏量:${_books[index]?.bookStock}",
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
            bottom: 0,
            right: 0,
            child: InkWell(
              splashColor: Colors.red,
              onTap: () => _cancelBorrowCar(index),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                ),
                child: Text(
                  "取消借阅",
                  style: TextStyle(fontSize: 22.sp, color: Colors.red),
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
      _books = await ApiRequest().getBorrowCarBookList();
    } catch (err) {}
    setState(() {
      _loading = false;
    });
  }

  /// 取消借阅
  _cancelBorrowCar(int index) async {
    setState(() {
      _loading = true;
    });
    try {
      await ApiRequest().cancelBorrowCar(_books[index].id);
      _books.removeAt(index);
    } catch (err) {}
    setState(() {
      _loading = false;
    });
  }

  /// 生成借阅吗
  _goToBorrow() {
    DateTime now = DateTime.now();
    CommonUtil.navigatorPush(
      BorrowAndReturnBookPage(
        type: PageType.PageTypeBorrow,
        books: _books
            .map(
              (e) => BorrowBookItem(
                bookId: e.bookId,
                name: e.bookName,
                image: e.bookImage,
                author: e.bookAuthor,
                category: e.bookFirstCate,
                startTime: now,
                endTime: now.add(Duration(days: 7)),
              ),
            )
            .toList(),
      ),
    );
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
        title: Text("借阅车"),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.w),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: _itemBuilder,
                    itemCount: _books.length,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border:
                          Border(top: BorderSide(color: Color(0xffcccccc)))),
                  padding: EdgeInsets.symmetric(vertical: 20.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text("请携带书籍前往机器或人工处进行扫描完成借阅"),
                      ),
                      RaisedButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: _goToBorrow,
                        child: Text("生成借阅码"),
                      ),
                    ],
                  ),
                ),
              ],
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
