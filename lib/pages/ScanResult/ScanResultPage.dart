import 'package:bookApp/components/CacheImageView.dart';
import 'package:bookApp/components/LoadingView.dart';
import 'package:bookApp/components/Toast.dart';
import 'package:bookApp/models/QRCodeData.dart';
import 'package:bookApp/network/ApiRequest.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

class ScanResultPage extends StatefulWidget {
  final QRCodeData result;

  ScanResultPage({this.result});

  @override
  State<StatefulWidget> createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  bool _loading = false;

  _onTapButton() async {
    setState(() {
      _loading = true;
    });
    try {
      if (widget.result.type == QRCodeType.Borrow) {
        await ApiRequest().borrowBooks(
            uid: widget.result.userId,
            bookIds: widget.result.books.map<int>((e) => e.bookId).toList());
      } else if (widget.result.type == QRCodeType.Return) {
        await ApiRequest().returnBooks(
            uid: widget.result.userId,
            recordIds:
                widget.result.books.map<int>((e) => e.recordId).toList());
      }
      CBToast.showSuccessToast(CommonUtil.rootContext, "操作成功");
      Navigator.of(context).pop();
    } catch (err) {
      CBToast.showErrorToast(context, "操作失败");
      print("[ERROR] $err");
    }
    setState(() {
      _loading = false;
    });
  }

  /// 列表项
  Widget _itemBuilder(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.w),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: 300.w,
                width: 200.w,
                margin: EdgeInsets.only(right: 30.w),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10.w)),
                clipBehavior: Clip.hardEdge,
                child: CacheImageView(
                  url:
                      "${CommonUtil.imageHost}${widget.result.books[index].image}",
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                  height: 300.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Text(
                          widget.result.books[index].name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          widget.result.books[index].author ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: Color(0xff666666),
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "${widget.result.books[index]?.category}",
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.result.type == QRCodeType.Return ? "图书归还" : "图书借阅"),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.w),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: _itemBuilder,
                    itemCount: widget.result.books.length,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      border:
                          Border(top: BorderSide(color: Color(0xffcccccc)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("借阅人ID: ${widget.result.userId}"),
                      FlatButton(
                        onPressed: _onTapButton,
                        child: Text(widget.result.type == QRCodeType.Borrow
                            ? "确认借阅"
                            : "确认归还"),
                        color: Colors.blue,
                        textColor: Colors.white,
                      )
                    ],
                  ),
                ),
              ],
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
