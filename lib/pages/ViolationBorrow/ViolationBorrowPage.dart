import 'package:bookApp/components/CacheImageView.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

class ViolationBorrowPage extends StatelessWidget {
  final List<Map> books;

  ViolationBorrowPage({this.books = const []});

  String _formatTime(String timeString) {
    return timeString.substring(0, 10);
  }

  int _restDay(String dateString) {
    return DateTime.parse(dateString).difference(DateTime.now()).inDays.abs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("违规记录"),
      ),
      body: Column(
        children: [
          Container(
            height: 250.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Color(0xffcccccc), width: 8))),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                    color: Color(0xff333333),
                    fontWeight: FontWeight.bold,
                    fontSize: 32.sp),
                children: [
                  TextSpan(
                    text: "${books.length}",
                    style: TextStyle(
                      fontSize: 60.sp,
                    ),
                  ),
                  TextSpan(text: "本"),
                ],
              ),
            ),
          ),
          Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
              color: Color(0xffF9F1CD),
              child: Text(
                "请到人工处进行处理",
                style: TextStyle(fontSize: 24.sp, color: Color(0xff666666)),
              )),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.w, horizontal: 20.w),
                      child: Row(
                        children: [
                          Container(
                            height: 300.w,
                            width: 200.w,
                            margin: EdgeInsets.only(right: 30.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.w)),
                            clipBehavior: Clip.hardEdge,
                            child: CacheImageView(
                              url:
                                  "${CommonUtil.imageHost}${books[index]["book_image"]}",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 300.w,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    child: Text(
                                      "${books[index]["book_name"]}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 36.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "${_formatTime(books[index]["start_time"])} 至 ${_formatTime(books[index]["end_time"])}",
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        color: Color(0xff666666),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "${books[index]["book_author"]}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        color: Color(0xff666666),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "${books[index]["book_first_cate"]}",
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        color: Color(0xff666666),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      child: Text(
                        "已超时${_restDay(books[index]["end_time"])}天",
                        style: TextStyle(
                          fontSize: 22.sp,
                          color: Colors.orange,
                        ),
                      ),
                      right: 20.w,
                      bottom: 20.w,
                    )
                  ],
                );
              },
              itemCount: books.length,
            ),
          ),
        ],
      ),
    );
  }
}
