import 'package:bookApp/models/Category.dart';
import 'package:bookApp/pages/BookList/BookListPage.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

/// 分类组件
class CategoryView extends StatelessWidget {
  final List<BookCategory> categoryList;
  final Function onTapAllCategory;

  CategoryView({
    this.categoryList = const [],
    this.onTapAllCategory,
  });

  _onTapItem(BookCategory category) {
    CommonUtil.navigatorPush(BookListPage(
      type: BookListPageType.BookListPageTypeCategory,
      bookCategory: category,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(bottom: 20.w),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.w),
              child: GestureDetector(
                onTap: onTapAllCategory,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("全部分类"),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Flex(
                direction: Axis.horizontal,
                children: categoryList.map<Widget>((category) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _onTapItem(category),
                      child: Column(
                        children: [
                          Container(
                            height: 100.w,
                            width: 100.w,
                            margin: EdgeInsets.only(bottom: 20.w),
                            decoration: BoxDecoration(
                              color: Color(0xcccccccc),
                              borderRadius: BorderRadius.circular(50.w),
                            ),
                            child: Icon(
                              Icons.view_headline,
                              size: 60.w,
                              color: Colors.white,
                            ),
                          ),
                          Text(category.name),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
