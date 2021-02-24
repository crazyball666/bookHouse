import 'package:bookApp/models/CarouselItem.dart';
import 'package:bookApp/models/Category.dart';
import 'package:bookApp/network/ApiRequest.dart';
import 'package:bookApp/pages/BookList/BookListPage.dart';
import 'package:bookApp/pages/Index/BannerView.dart';
import 'package:bookApp/pages/Index/BooksTabBar.dart';
import 'package:bookApp/pages/Index/CategoryView.dart';
import 'package:bookApp/pages/Index/RecommendBookListView.dart';
import 'package:bookApp/pages/Index/SearchBar.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:flutter/material.dart';

class IndexPage extends StatefulWidget {
  final Function onTapAllCategory;

  IndexPage({this.onTapAllCategory});

  @override
  State<StatefulWidget> createState() => IndexPageState();
}

class IndexPageState extends State<IndexPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  FocusNode _searchFocusNode = FocusNode();
  TabController _tabController;
  PageController _pageController;
  List<String> _tabs = ["热门推荐", "新书上线", "借阅最高"];
  ValueNotifier<List<CarouselItem>> _carouselItemList =
      ValueNotifier<List<CarouselItem>>([]);
  ValueNotifier<List<BookCategory>> _categoryList =
      ValueNotifier<List<BookCategory>>([]);

  /// 搜索
  void _onSearch(String text) {
    print(text);
    if (text.isEmpty) {
      return;
    }
    CommonUtil.navigatorPush(BookListPage(
      type: BookListPageType.BookListPageTypeSearch,
      searchText: text,
    ));
  }

  /// tab切换
  void _onTabChange(int index) {
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  /// tab页面切换
  void _onPageChange(int page) {
    _tabController.animateTo(page);
  }

  /// 轮播图数据
  void _fetchCarouselData() async {
    try {
      _carouselItemList.value = await ApiRequest().getCarouselItemList();
    } catch (err) {
      print("【Error】$err");
    }
  }

  /// 分类数据
  void _fetchCategoryData() async {
    try {
      _categoryList.value = await ApiRequest().getIndexPageCategoryList();
    } catch (err) {
      print("【Error】$err");
    }
  }

  /// 获取数据
  void _fetchData() async {
    _fetchCarouselData();
    _fetchCategoryData();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _pageController = PageController();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    print("-- index page build --");
    return Listener(
      onPointerDown: (event) {
        if (_searchFocusNode.hasFocus) {
          _searchFocusNode.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: SearchBar(
          focusNode: _searchFocusNode,
          onSearch: _onSearch,
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              ValueListenableBuilder(
                valueListenable: _carouselItemList,
                builder: (context, snapshot, child) {
                  return BannerView(
                    carouselData: _carouselItemList.value,
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: _categoryList,
                builder: (context, snapshot, child) {
                  return CategoryView(
                    onTapAllCategory: widget.onTapAllCategory,
                    categoryList: _categoryList.value,
                  );
                },
              ),
              BooksTabBar(
                controller: _tabController,
                onChange: _onTabChange,
                tabs: _tabs,
              ),
            ];
          },
          body: PageView(
            controller: _pageController,
            onPageChanged: _onPageChange,
            children: [
              RecommendBookListView(RecommendType.RecommendTypePopular),
              RecommendBookListView(RecommendType.RecommendTypeNew),
              RecommendBookListView(RecommendType.RecommendTypeBorrow),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
