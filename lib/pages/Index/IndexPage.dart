import 'package:bookApp/pages/Index/BannerView.dart';
import 'package:bookApp/pages/Index/BooksTabBar.dart';
import 'package:bookApp/pages/Index/CategoryView.dart';
import 'package:bookApp/pages/Index/SearchBar.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexPageState();
}

class IndexPageState extends State<IndexPage>
    with SingleTickerProviderStateMixin {
  FocusNode _searchFocusNode = FocusNode();
  TabController _tabController;
  List<String> _tabs = ["热门推荐", "新书上线", "借阅最高"];

  void _onSearch(String text) {
    print(text);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        if (_searchFocusNode.hasFocus) {
          _searchFocusNode.unfocus();
        }
      },
      child: Scaffold(
        appBar: SearchBar(
          focusNode: _searchFocusNode,
          onSearch: _onSearch,
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              BannerView(),
              CategoryView(
                categoryList: ["1", "2", "3", "4"],
              ),
              BooksTabBar(
                controller: _tabController,
                tabs: _tabs,
              ),
            ];
          },
          body: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text("标题$index"),
              );
            },
            itemCount: 50,
          ),
        ),
      ),
    );
  }
}
