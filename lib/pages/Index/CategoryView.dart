import 'package:bookApp/models/Category.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

/// 分类组件
class CategoryView extends StatelessWidget {
  final List<BookCategory> categoryList;

  CategoryView({this.categoryList = const []});

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
                    child: Column(
                      children: [
                        Container(
                          height: 100.w,
                          width: 100.w,
                          margin: EdgeInsets.only(bottom: 20.w),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(50.w),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    "https://static.crazyball.xyz/uploads/2020-07-19/1595154126_53ykv0ieyfy.jpeg"),
                              )),
                        ),
                        Text(category.name),
                      ],
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
