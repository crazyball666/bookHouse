import 'package:bookApp/components/BookListView.dart';
import 'package:bookApp/components/LoadingView.dart';
import 'package:bookApp/models/Book.dart';
import 'package:bookApp/models/Category.dart';
import 'package:bookApp/models/ListResult.dart';
import 'package:bookApp/network/ApiRequest.dart';
import 'package:bookApp/pages/BookList/BookListTag.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

enum BookListPageType {
  BookListPageTypeSearch,
  BookListPageTypeCategory,
}

class BookListPage extends StatefulWidget {
  final BookListPageType type;
  final String searchText;
  final BookCategory bookCategory;

  BookListPage({
    this.type,
    this.searchText,
    this.bookCategory,
  });

  @override
  State<StatefulWidget> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage>
    with SingleTickerProviderStateMixin {
  List<Book> _bookList = [];
  TabController _tabController;
  int _nextPage = 1;
  ValueNotifier<bool> _loading = ValueNotifier<bool>(false);
  int _selectedTabIndex = 0;

  _onTapTabItem(int index, BookListSort sort) {
    if(_selectedTabIndex == index && index == 0) return;
    _selectedTabIndex = index;
    String column = "";
    String order = "";
    if(index == 1){
      column = "score";
    }else if(index == 2){
      column = "collect_count";
    }
    if(sort == BookListSort.BookListSortDes){
      order = "desc";
    }else if(sort == BookListSort.BookListSortAsc){
      order = "asc";
    }
    _fetchData(column: column,order: order);
  }

  _fetchData({
    String column = "",
    String order = "",
  }) async {
    _loading.value = true;
    try {
      ListResult<Book> booksResult = await ApiRequest().getBookList(
        page: _nextPage,
        searchText: widget.type == BookListPageType.BookListPageTypeSearch
            ? widget.searchText
            : "",
        categoryId: widget.type == BookListPageType.BookListPageTypeCategory
            ? widget.bookCategory.id
            : 0,
        column: column,
        order: order,
      );
      _bookList.addAll(booksResult.data);
    } catch (err) {
      print("【Error】$err");
    }
    _loading.value = false;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    print(_bookList);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.type == BookListPageType.BookListPageTypeSearch
            ? widget.searchText
            : widget.bookCategory.name),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              children: [
                BookListTab(
                  controller: _tabController,
                  onTapItem: _onTapTabItem,
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: _loading,
                    builder: (context, snapshot, child) {
                      return AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: Container(
                          key: ValueKey<bool>(_loading.value),
                          child: _loading.value
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : BookListView(
                                  books: _bookList,
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder(
              valueListenable: _loading,
              builder: (context, snapshot, child) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: _loading.value ? LoadingView() : Container(),
                );
              })
        ],
      ),
    );
  }
}
