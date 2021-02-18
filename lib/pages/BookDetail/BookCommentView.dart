import 'package:bookApp/components/CacheImageView.dart';
import 'package:bookApp/models/Comment.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';
import 'package:intl/intl.dart';

class BookCommentView extends StatefulWidget {
  final List<Comment> commentList;

  BookCommentView({
    this.commentList = const [],
  });

  @override
  State<StatefulWidget> createState() => _BookCommentViewState();
}

class _BookCommentViewState extends State<BookCommentView> {
  @override
  void initState() {
    super.initState();
  }

  Widget _commentItemView(BuildContext context, int index) {
    Comment comment = widget.commentList[index];
    String date =
        DateFormat('yyyy-MM-dd').format(comment.createTime ?? DateTime.now());

    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80.w,
            width: 80.w,
            margin: EdgeInsets.only(right: 20.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80.w),
            ),
            clipBehavior: Clip.hardEdge,
            child: CacheImageView(url: "${comment.userAvatar}"),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.userName ?? "",
                  style:
                      TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.w),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: Text(
                          date,
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Color(0xffbbbbbb),
                          ),
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index > comment.score
                                ? Icons.star_border
                                : Icons.star,
                            color: Colors.green,
                            size: 30.w,
                          ),
                        ).toList(),
                      )
                    ],
                  ),
                ),
                Text(
                  comment.content ?? "",
                  style: TextStyle(
                    fontSize: 25.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: widget.commentList.isEmpty
          ? Center(
              child: Text(
                "暂无评价",
                style: TextStyle(color: Color(0xff666666)),
              ),
            )
          : ListView.builder(
              itemBuilder: _commentItemView,
              itemCount: widget.commentList.length,
            ),
    );
  }
}
