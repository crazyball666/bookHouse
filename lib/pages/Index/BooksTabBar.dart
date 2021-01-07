import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

class BooksTabBar extends StatefulWidget {
  final List<String> tabs;
  final TabController controller;

  BooksTabBar({
    this.tabs = const [],
    @required this.controller,
  });

  @override
  State<StatefulWidget> createState() => _BooksTabBarState();
}

class _BooksTabBarState extends State<BooksTabBar> {
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: _BooksTabBarDelegate(
        tabs: widget.tabs.map((tab) => Text(tab)).toList(),
        tabController: widget.controller,
      ),
      pinned: true,
    );
  }
}

class _BooksTabBarDelegate extends SliverPersistentHeaderDelegate {
  List<Widget> tabs;
  TabController tabController;

  _BooksTabBarDelegate({
    this.tabs = const [],
    this.tabController,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 20.w),
      height: 80.w,
      child: TabBar(
        indicatorPadding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        indicatorWeight: 2.w,
        labelStyle: TextStyle(
          fontSize: 28.w,
        ),
        labelColor: Colors.blue,
        unselectedLabelStyle: TextStyle(
          fontSize: 24.w,
        ),
        unselectedLabelColor: Color(0xFF666666),
        tabs: tabs,
        controller: tabController,
      ),
    );
  }

  @override
  double get maxExtent => 80.w;

  @override
  double get minExtent => 80.w;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
