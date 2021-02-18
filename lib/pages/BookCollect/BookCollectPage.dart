import 'package:bookApp/components/CacheImageView.dart';
import 'package:bookApp/components/LoadingView.dart';
import 'package:bookApp/network/ApiRequest.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

class BookCollectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BookCollectPageState();
}

class _BookCollectPageState extends State<BookCollectPage> {
  bool _loading = false;
  List<Map> _books = [];

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
                          "分类：${_books[index]["book_first_cate"]} ${_books[index]["second_first_cate"]}",
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: Color(0xff666666),
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "馆藏量：${_books[index]["book_stock"]}本",
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
              onTap: () => _cancelCollectCar(index),
              child: Column(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 48.w,
                  ),
                  Text(
                    "取消收藏",
                    style: TextStyle(fontSize: 20.sp, color: Color(0xff666666)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 取消收藏
  _cancelCollectCar(int index) async {
    setState(() {
      _loading = true;
    });
    try {
      await ApiRequest().cancelCollect(_books[index]["book_id"]);
      _books.removeAt(index);
    } catch (err) {}
    setState(() {
      _loading = false;
    });
  }

  /// 获取数据
  _fetchData() async {
    setState(() {
      _loading = true;
    });
    try {
      _books = await ApiRequest().getCollectBookList();
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
        title: Text("我的收藏"),
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
