import 'package:bookApp/components/LoadingView.dart';
import 'package:bookApp/components/Toast.dart';
import 'package:bookApp/network/ApiRequest.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

class BookCommentPage extends StatefulWidget {
  int id;
  final int bookId;
  final String content;
  final int score;

  BookCommentPage({
    this.id = 0,
    this.bookId,
    this.content = "",
    this.score = 0,
  });

  @override
  State<StatefulWidget> createState() => _BookCommentPageState();
}

class _BookCommentPageState extends State<BookCommentPage> {
  TextEditingController _textEditingController = TextEditingController();
  int _score = 0;
  bool _loading = false;

  _submitComment() async {
    String content = _textEditingController.text;
    if (_score == 0 || content.isEmpty) {
      CBToast.showErrorToast(context, "请填写完整评价信息");
      return;
    }
    setState(() {
      _loading = true;
    });
    try {
      await ApiRequest().addComment(
        bookId: widget.bookId,
        score: _score,
        content: content,
      );
      CBToast.showErrorToast(context, "评价成功");
      widget.id = 999;
    } catch (err) {
      CBToast.showErrorToast(context, "评价失败");
    }
    setState(() {
      _loading = false;
    });
  }

  _onSelectedScore(int index) {
    setState(() {
      _score = index + 1;
    });
  }

  @override
  void initState() {
    super.initState();
    _score = widget.score;
    _textEditingController.text = widget.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("图书评价"),
      ),
      body: Stack(
        children: [
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30.w, horizontal: 30.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "总体评分 ",
                        style: TextStyle(fontSize: 28.sp),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) => GestureDetector(
                            onTap: widget.id > 0
                                ? null
                                : () => _onSelectedScore(index),
                            child: Icon(
                              index >= _score ? Icons.star_border : Icons.star,
                              color: Colors.green,
                              size: 40.w,
                            ),
                          ),
                        ).toList(),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.only(top: 20.w),
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xff999999)),
                            borderRadius: BorderRadius.circular(8)),
                        child: TextField(
                          enabled: widget.id == 0,
                          controller: _textEditingController,
                          maxLengthEnforced: true,
                          maxLength: 200,
                          maxLines: null,
                          style: TextStyle(color: Color(0xff666666)),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.all(16.w),
                            // filled: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 300.w,
                    child: RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: widget.id > 0 ? null : _submitComment,
                      child: Text(widget.id > 0 ? "已评价" : "提交评价"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _loading ? LoadingView() : Container(),
          ),
        ],
      ),
    );
  }
}
