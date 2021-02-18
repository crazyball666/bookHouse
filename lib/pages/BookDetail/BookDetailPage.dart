import 'package:bookApp/components/CacheImageView.dart';
import 'package:bookApp/components/Toast.dart';
import 'package:bookApp/models/Book.dart';
import 'package:bookApp/models/BorrowBookItem.dart';
import 'package:bookApp/models/Comment.dart';
import 'package:bookApp/models/HistoryBook.dart';
import 'package:bookApp/models/ListResult.dart';
import 'package:bookApp/network/ApiRequest.dart';
import 'package:bookApp/pages/BookDetail/BookCommentView.dart';
import 'package:bookApp/components/LoadingView.dart';
import 'package:bookApp/pages/BorrowAndReturnBook/BorrowAndReturnBookPage.dart';
import 'package:bookApp/pages/Login/LoginPage.dart';
import 'package:bookApp/provider/UserProvider.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:bookApp/util/PreferencesUtil.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';
import 'package:provider/provider.dart';

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
  bool _loadingComment = false;
  ValueNotifier<bool> _loading = ValueNotifier<bool>(false);

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
    _loading.value = true;
    try {
      _book = await ApiRequest().getBookDetail(_book.id);
      setState(() {});
    } catch (err) {
      print("【Error】$err");
    }
    _loading.value = false;
  }

  /// 获取评论数据
  _fetchCommentData(int page) async {
    setState(() {
      _loadingComment = true;
    });
    try {
      ListResult<Comment> result =
          await ApiRequest().getCommentList(_book.id, page);
      List<Comment> newList = List.from(_commentList.value);
      newList.addAll(result.data);
      _commentList.value = newList;
      _totalPage = result.totalPage;
      if (_nextPage < _totalPage) {
        _nextPage++;
      }
    } catch (err) {
      print("【Error】$err");
    }
    setState(() {
      _loadingComment = false;
    });
  }

  /// 收藏
  _collectBook() async {
    if (!await _checkLoginStatus()) {
      return;
    }
    _loading.value = true;
    try {
      await ApiRequest().addCollect(_book.id);
      CBToast.showSuccessToast(context, "收藏成功");
      setState(() {
        _book.isCollect = true;
      });
    } catch (err) {
      CBToast.showErrorToast(context, "收藏失败");
    }
    _loading.value = false;
  }

  /// 取消收藏
  _cancelCollectBook() async {
    if (!await _checkLoginStatus()) {
      return;
    }
    _loading.value = true;
    try {
      await ApiRequest().cancelCollect(_book.id);
      CBToast.showSuccessToast(context, "已取消收藏");
      setState(() {
        _book.isCollect = false;
      });
    } catch (err) {
      CBToast.showErrorToast(context, "取消收藏失败");
    }
    _loading.value = false;
  }

  /// 加入借阅车
  _addBorrowCar() async {
    if (!await _checkLoginStatus()) {
      return;
    }
    _loading.value = true;
    try {
      await ApiRequest().addBorrowCar(bookId: _book.id);
      CBToast.showSuccessToast(context, "已添加至借阅车～");
      setState(() {
        _book.isBorrow = true;
      });
    } catch (err) {
      CBToast.showErrorToast(context, "添加失败");
    }
    _loading.value = false;
  }

  /// 借阅
  _borrowBook() async {
    if (!await _checkLoginStatus()) {
      return;
    }
    DateTime now = DateTime.now();
    CommonUtil.navigatorPush(
      BorrowAndReturnBookPage(
        type: PageType.PageTypeBorrow,
        books: [
          BorrowBookItem(
            bookId: _book.id,
            name: _book.name,
            image: _book.image,
            author: _book.author,
            category: _book.firstCate,
            startTime: now,
            endTime: now.add(Duration(days: 7)),
          ),
        ],
      ),
    );
  }

  /// 检查登录状态
  Future<bool> _checkLoginStatus() async {
    bool isLogin = Provider.of<UserProvider>(context, listen: false).isLogin;
    if (isLogin) return true;
    await LoginPage.showLoginPage();
    return Provider.of<UserProvider>(context, listen: false).isLogin;
  }

  @override
  void initState() {
    super.initState();
    _book = widget.book;
    _fetchBookData();
    _fetchCommentData(_nextPage);
    PreferencesUtil.addHistoryBook(HistoryBook(
        id: _book.id,
        image: _book.image,
        name: _book.name,
        author: _book.author,
        stock: _book.stock,
        category: "${_book.firstCategory.name} ${_book.secondCategory.name}"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_book.name),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
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
                            url: "${CommonUtil.imageHost}${_book.image}",
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "作者：${_book.author}",
                                  style: TextStyle(
                                    color: Color(0xff666666),
                                    fontSize: 24.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "分类：${_book.firstCate ?? ""} ${_book.secondCate ?? ""}",
                                  style: TextStyle(
                                    color: Color(0xff666666),
                                    fontSize: 24.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "馆藏量：${_book.stock}",
                                  style: TextStyle(
                                    color: Color(0xff666666),
                                    fontSize: 24.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "书籍编码：${_book.bookCode}",
                                  style: TextStyle(
                                    color: Color(0xff666666),
                                    fontSize: 24.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "书籍位置：${_book.place}",
                                  style: TextStyle(
                                    color: Color(0xff666666),
                                    fontSize: 24.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                                      child: Icon(
                                        _book.isCollect
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.yellow,
                                      ),
                                      onTap: _book.isCollect
                                          ? _cancelCollectBook
                                          : _collectBook,
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
                    child: Text(_book.introduction.isEmpty
                        ? "暂无简介"
                        : _book.introduction),
                  ),
                ),
              ];
            },
            body: Container(
              child: Column(
                children: [
                  _titleWidget("读者评价"),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: _commentList,
                      builder: (context, snapshot, child) {
                        return _loadingComment
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : BookCommentView(
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
                            onPressed: _book.isBorrow ? null : _addBorrowCar,
                            child: Text(
                              _book.isBorrow ? "已添加借阅车" : "加入借阅车",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.blue,
                            disabledColor: Colors.grey,
                          ),
                          FlatButton(
                            onPressed: _borrowBook,
                            child: Text(
                              "立即借阅",
                              style: TextStyle(color: Colors.white),
                            ),
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
          ValueListenableBuilder(
            valueListenable: _loading,
            builder: (context, snapshot, child) {
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: _loading.value ? LoadingView() : Container(),
              );
            },
          ),
        ],
      ),
    );
  }
}
