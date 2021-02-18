import 'package:bookApp/components/CacheImageView.dart';
import 'package:bookApp/components/LoadingView.dart';
import 'package:bookApp/models/HistoryBook.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:bookApp/util/PreferencesUtil.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

class BrowsingHistoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BrowsingHistoryPageState();
}

class _BrowsingHistoryPageState extends State<BrowsingHistoryPage> {
  bool _loading = false;
  List<HistoryBook> _books = [];

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
                  url: "${CommonUtil.imageHost}${_books[index].image}",
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
                          "${_books[index].name}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "作者：${_books[index].author}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: Color(0xff666666),
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "分类：${_books[index]?.category}",
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: Color(0xff666666),
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "馆藏量：${_books[index]?.stock}",
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
      _books = await PreferencesUtil.getHistoryBookList();
    } catch (err) {}
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
        title: Text("浏览记录"),
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
