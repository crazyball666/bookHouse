import 'package:bookApp/components/CacheImageView.dart';
import 'package:bookApp/components/Toast.dart';
import 'package:bookApp/models/Book.dart';
import 'package:bookApp/models/Comment.dart';
import 'package:bookApp/models/ListResult.dart';
import 'package:bookApp/network/ApiRequest.dart';
import 'package:bookApp/pages/BookDetail/BookCommentView.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;

  BookDetailPage(this.book);

  @override
  State<StatefulWidget> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  Book _book;
  ValueNotifier<List<Comment>> _commentList = ValueNotifier<List<Comment>>([]);
  int _nextPage = 1;
  int _totalPage = 1;

  Widget _titleWidget(String title) {
    return Container(
      height: 60.w,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Colors.blue,
            width: 3,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 32.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  ///获取书籍数据
  _fetchBookData() async {
    try {
      _book = await ApiRequest().getBookDetail(widget.book.id);
      setState(() {});
    } catch (err) {
      print("【Error】$err");
    }
  }

  /// 获取评论数据
  _fetchCommentData(int page) async {
    try {
      ListResult<Comment> result =
          await ApiRequest().getCommentList(_book.id, page);
      List<Comment> newList = List.from(_commentList.value);
      newList.addAll(result.data);
      newList.addAll(result.data);
      newList.addAll(result.data);
      newList.addAll(result.data);
      _commentList.value = newList;
      _totalPage = result.totalPage;
      if (_nextPage < _totalPage) {
        _nextPage++;
      }
    } catch (err) {
      print("【Error】$err");
    }
  }

  @override
  void initState() {
    super.initState();
    _book = widget.book;
    _fetchBookData();
    _fetchCommentData(_nextPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_book.name),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
                  margin: EdgeInsets.only(bottom: 20.w),
                  child: Row(
                    children: [
                      Container(
                        height: 300.w,
                        width: 200.w,
                        child: CacheImageView(
                          url: _book.image,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 300.w,
                          padding: EdgeInsets.symmetric(horizontal: 30.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                _book.name,
                                style: TextStyle(
                                  fontSize: 36.sp,
                                ),
                              ),
                              Text(
                                "作者：${_book.author}",
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: 24.sp,
                                ),
                              ),
                              Text(
                                "分类：${_book.firstCategory.name} ${_book.secondCategory.name}",
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: 24.sp,
                                ),
                              ),
                              Text(
                                "馆藏量：${_book.total}",
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: 24.sp,
                                ),
                              ),
                              Text(
                                "书籍编码：${_book.bookCode}",
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: 24.sp,
                                ),
                              ),
                              Text(
                                "书籍位置：${_book.place}",
                                style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: 24.sp,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${_book.scoreAvg.toStringAsFixed(1)}分 ",
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 36.sp,
                                          ),
                                        ),
                                        Text(
                                          " ${_book.collectCount}人收藏",
                                          style: TextStyle(
                                            color: Color(0xff666666),
                                            fontSize: 24.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    child: Icon(Icons.star_border),
                                    // onPressed: null,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _titleWidget("简介"),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(
                      left: 20.w, right: 20.w, bottom: 40.w, top: 10.w),
                  child: Text(
                      _book.introduction.isEmpty ? "暂无简介" : _book.introduction),
                ),
              ),
              SliverPersistentHeader(
                delegate: _BookCommentHeaderDelegate(
                  _titleWidget("读者评价"),
                ),
                pinned: true,
              )
            ];
          },
          body: Container(
            child: Column(
              children: [
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: _commentList,
                    builder: (context, snapshot, child) {
                      return BookCommentView(
                        commentList: _commentList.value,
                      );
                    },
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          onPressed: () {},
                          child: Text("加入借阅车"),
                          color: Colors.blue,
                        ),
                        FlatButton(
                          onPressed: () {},
                          child: Text("立即借阅"),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BookCommentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _BookCommentHeaderDelegate(this.child);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      height: 60.w,
      child: child,
    );
  }

  @override
  double get maxExtent => 60.w;

  @override
  double get minExtent => 60.w;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
