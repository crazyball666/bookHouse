import 'package:bookApp/components/CacheImageView.dart';
import 'package:bookApp/models/Book.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

class BorrowBoolListView extends StatelessWidget {
  final String title;
  final List<Book> books;

  BorrowBoolListView({
    this.title,
    this.books,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20.w, left: 10.w, right: 10.w),
            child: Text(
              title,
              style: TextStyle(fontSize: 32.sp),
            ),
          ),
          Flex(
            direction: Axis.horizontal,
            children: books
                .map(
                  (book) => Flexible(
                    child: Container(
                      height: 300.w,
                      width: double.infinity,
                      // color: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        children: [
                          Expanded(
                            child: SizedBox.expand(
                              child: CacheImageView(
                                url: "${CommonUtil.baseHost}${book.image}",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5.w),
                            child: Text(
                              book.name,
                              style: TextStyle(fontSize: 26.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.w),
            alignment: Alignment.center,
            child: GestureDetector(
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Text(
                  "查看全部",
                  style: TextStyle(
                    fontSize: 26.sp,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
