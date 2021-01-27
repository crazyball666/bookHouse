import 'package:bookApp/models/Category.dart';
import 'package:bookApp/network/ApiRequest.dart';
import 'package:bookApp/pages/BookList/BookListPage.dart';
import 'package:bookApp/pages/Index/SearchBar.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

class CategoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with AutomaticKeepAliveClientMixin {
  bool _loading = true;
  ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);
  List<BookCategory> _allCategory = [];
  List<BookCategory> _allSecondCategory = [];

  List<BookCategory> get _secondCategoryList {
    if (_selectedIndex.value == 0) {
      if (_allSecondCategory.isEmpty) {
        _allCategory.forEach((firstCategory) {
          _allSecondCategory.addAll(firstCategory.children);
        });
      }
      return _allSecondCategory;
    } else {
      return _allCategory[_selectedIndex.value - 1].children;
    }
  }

  FocusNode _searchFocusNode = FocusNode();

  /// 搜索
  void _onSearch(String text) {
    print(text);
    if(text.isEmpty){
      return;
    }
    CommonUtil.navigatorPush(BookListPage(
      type: BookListPageType.BookListPageTypeSearch,
      searchText: text,
    ));
  }

  ///选中一级分类
  _onSelectFirstCategory(int index) {
    _selectedIndex.value = index;
  }

  /// 选中二级分类
  _onSelectSecondCategory(BookCategory bookCategory) {
    print(bookCategory.name);
    CommonUtil.navigatorPush(BookListPage(
      type: BookListPageType.BookListPageTypeCategory,
      bookCategory: bookCategory,
    ));
  }

  /// 左边一级分类
  Widget _firstCategoryItem(BuildContext context, int index) {
    bool isSelected = index == _selectedIndex.value;
    return InkWell(
      onTap: () => _onSelectFirstCategory(index),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: 90.w,
            alignment: Alignment.center,
            color: isSelected ? Colors.white : Color(0xffeeeeee),
            child: Text(
              index == 0 ? "全部分类" : _allCategory[index - 1].name,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.black,
                fontSize: 25.sp,
              ),
            ),
          ),
          Positioned(
            top: 20.w,
            bottom: 20.w,
            left: 10.w,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: 15.w,
              color: Colors.blue,
              transform:
                  Matrix4.translationValues(isSelected ? 0 : -35.w, 0, 0),
            ),
          )
        ],
      ),
    );
  }

  void _fetchData() async {
    try {
      _allCategory = await ApiRequest().getAllCategory();
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
    return Listener(
      onPointerDown: (event) {
        if (_searchFocusNode.hasFocus) {
          _searchFocusNode.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomPadding:false,
        appBar: SearchBar(
          focusNode: _searchFocusNode,
          onSearch: _onSearch,
        ),
        body: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: Container(
            key: ValueKey(_loading),
            child: _loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Row(
                    children: [
                      Container(
                        height: double.infinity,
                        width: 220.w,
                        color: Color(0xffeeeeee),
                        child: ValueListenableBuilder(
                          valueListenable: _selectedIndex,
                          builder: (context, snapshot, child) {
                            return ListView.builder(
                              itemBuilder: _firstCategoryItem,
                              itemCount: _allCategory.length + 1,
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 20.w),
                          child: SingleChildScrollView(
                            child: ValueListenableBuilder(
                              valueListenable: _selectedIndex,
                              builder: (context, snapshot, child) {
                                return Wrap(
                                  children: _secondCategoryList
                                      .map((e) => Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 20.w,
                                                vertical: 20.w),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xffbbbbbb)),
                                              borderRadius:
                                                  BorderRadius.circular(10.w),
                                            ),
                                            child: InkWell(
                                              onTap: () =>
                                                  _onSelectSecondCategory(e),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 28.w,
                                                    vertical: 16.w),
                                                child: Text(
                                                  e.name,
                                                  style: TextStyle(
                                                      color: Color(0xff333333)),
                                                ),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                );
                              },
                            ),
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

  @override
  bool get wantKeepAlive => true;
}
