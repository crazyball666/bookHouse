import 'package:bookApp/components/BookListView.dart';
import 'package:bookApp/models/Book.dart';
import 'package:bookApp/network/ApiRequest.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

class RecommendBookListView extends StatefulWidget {
  final RecommendType type;

  RecommendBookListView(this.type);

  @override
  State<StatefulWidget> createState() => _RecommendBookListViewState();
}

class _RecommendBookListViewState extends State<RecommendBookListView>
    with AutomaticKeepAliveClientMixin {
  List<Book> _bookList = [];
  bool _loading = true;

  @override
  bool get wantKeepAlive => true;

  void _fetchData() async {
    try {
      _bookList = await ApiRequest().getIndexPageRecommendBookList(widget.type);
    } catch (err) {
      print("【Error】$err");
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: Container(
          key: ValueKey(_loading),
          child: _loading
              ? Container(
                  // height: 100.w,
                  child: CircularProgressIndicator(),
                )
              : BookListView(
                  books: _bookList,
                ),
        ),
      ),
    );
  }
}
