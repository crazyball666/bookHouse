import 'package:bookApp/models/Book.dart';
import 'package:bookApp/pages/BookDetail/BookDetailPage.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

/// 书籍列表组件
class BookListView extends StatelessWidget {
  final List<Book> books;

  BookListView({this.books = const []});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        Book book = books[index];
        return InkWell(
          onTap: () {
            CommonUtil.navigatorPush(BookDetailPage(book));
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 30.w),
            child: Row(
              children: [
                Container(
                  height: 300.w,
                  width: 200.w,
                  margin: EdgeInsets.only(right: 30.w),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10.w)),
                  clipBehavior: Clip.hardEdge,
                  child: CachedNetworkImage(
                    imageUrl: book.image,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, err) {
                      return CachedNetworkImage(
                        imageUrl:
                            "https://static.crazyball.xyz/uploads/2020-07-19/1595154126_53ykv0ieyfy.jpeg",
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Container(
                  height: 300.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Text(
                          book.name,
                          style: TextStyle(
                              fontSize: 36.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        child: Text(
                          book.author,
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: Color(0xff666666),
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "${book?.firstCategory?.name} ${book?.secondCategory?.name}",
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: Color(0xff666666),
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              child: Text(
                                "${book.scoreAvg.toStringAsFixed(1)}分",
                                style: TextStyle(
                                  fontSize: 36.sp,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20.w),
                              child: Text(
                                "${book.readCount}人已阅读",
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  color: Color(0xff666666),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: books.length,
    );
  }
}
