import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

enum BookListSort {
  BookListSortAsc,
  BookListSortDes,
}

class BookListTab extends StatefulWidget {
  final Function(int, BookListSort) onTapItem;
  final TabController controller;
  final BookListSort sort;

  BookListTab({
    this.onTapItem,
    this.controller,
    this.sort = BookListSort.BookListSortAsc,
  });

  @override
  State<StatefulWidget> createState() => _BookListTabState();
}

class _BookListTabState extends State<BookListTab> {
  int _selectedIndex = 0;

  List<_TabItemModel> _tabList = [
    _TabItemModel(title: "默认顺序"),
    _TabItemModel(title: "评分", sort: BookListSort.BookListSortAsc),
    _TabItemModel(title: "收藏量", sort: BookListSort.BookListSortAsc),
  ];

  _onTapItem(int index) {
    if (_selectedIndex == index) {
      if (_tabList[index].sort == BookListSort.BookListSortAsc) {
        _tabList[index].sort = BookListSort.BookListSortDes;
      } else if (_tabList[index].sort == BookListSort.BookListSortDes) {
        _tabList[index].sort = BookListSort.BookListSortAsc;
      }
    }
    _selectedIndex = index;
    setState(() {});
    if (widget.onTapItem != null) {
      widget.onTapItem(index, _tabList[index].sort);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TabBar(
        controller: widget.controller,
        labelColor: Colors.orange,
        unselectedLabelColor: Colors.black,
        indicatorColor: Colors.orange,
        labelPadding: EdgeInsets.symmetric(vertical: 20.w),
        tabs: _tabList
            .map(
              (e) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(e.title),
                  e.sort != null
                      ? Icon(
                          e.sort == BookListSort.BookListSortAsc
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                        )
                      : Container(),
                ],
              ),
            )
            .toList(),
        onTap: _onTapItem,
      ),
    );
  }
}

class _TabItemModel {
  String title;
  BookListSort sort;

  _TabItemModel({
    this.title,
    this.sort,
  });
}
