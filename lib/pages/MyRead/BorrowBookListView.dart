import 'package:bookApp/components/CacheImageView.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

class BorrowBoolListView extends StatelessWidget {
  final String title;
  final List<Map> books;
  final Function onTap;

  BorrowBoolListView({
    this.title,
    this.books,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 20.w),
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
          books.isEmpty
              ? Container(
                  height: 200.w,
                  alignment: Alignment.center,
                  child: Text(
                    "暂无借阅",
                    style: TextStyle(color: Color(0xff999999)),
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 20.w,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: books.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        children: [
                          Expanded(
                            child: SizedBox.expand(
                              child: CacheImageView(
                                url:
                                    "${CommonUtil.imageHost}${books[index]["book_image"]}",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5.w),
                            child: Text(
                              books[index]["book_name"],
                              style: TextStyle(fontSize: 26.sp),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
          books.isEmpty
              ? Container()
              : Container(
                  padding: EdgeInsets.only(top: 16.w),
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: onTap,
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
