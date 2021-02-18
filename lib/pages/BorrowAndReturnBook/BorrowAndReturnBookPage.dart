import 'package:bookApp/components/CacheImageView.dart';
import 'package:bookApp/models/BorrowBookItem.dart';
import 'package:bookApp/models/QRCodeData.dart';
import 'package:bookApp/provider/UserProvider.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

enum PageType {
  PageTypeBorrow,
  PageTypeReturn,
}

class BorrowAndReturnBookPage extends StatefulWidget {
  final PageType type;
  final List<BorrowBookItem> books;

  BorrowAndReturnBookPage({
    this.type = PageType.PageTypeBorrow,
    this.books = const [],
  });

  @override
  State<StatefulWidget> createState() => _BorrowAndReturnBookPageState();
}

class _BorrowAndReturnBookPageState extends State<BorrowAndReturnBookPage> {
  String get _qrCodeDataString {
    try {
      return QRCodeData(
        type: widget.type == PageType.PageTypeBorrow
            ? QRCodeType.Borrow
            : QRCodeType.Return,
        userId: Provider.of<UserProvider>(context, listen: false).user.id,
        userName: Provider.of<UserProvider>(context, listen: false).user.name,
        books: widget.books,
      ).jsonString;
    } catch (err) {}
    return "";
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
                  url: "${CommonUtil.imageHost}${widget.books[index].image}",
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
                          widget.books[index].name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          widget.books[index].author ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: Color(0xff666666),
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "${widget.books[index]?.category}",
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
        title: Text(widget.type == PageType.PageTypeBorrow ? "图书借阅" : "图书归还"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.w),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: _itemBuilder,
                itemCount: widget.books.length,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "当前" +
                            (widget.type == PageType.PageTypeBorrow
                                ? "借阅"
                                : "归还") +
                            "书籍",
                        style: TextStyle(color: Colors.black, fontSize: 24.sp)),
                    TextSpan(
                        text: "${widget.books.length}本",
                        style:
                            TextStyle(color: Colors.orange, fontSize: 36.sp)),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xffcccccc)))),
              padding: EdgeInsets.symmetric(vertical: 20.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text("请携带书籍前往机器或人工处出示该二维码与书籍条形码行扫描"),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.w),
                    height: 300.w,
                    width: 300.w,
                    child: QrImage(
                      size: 300.w,
                      data: _qrCodeDataString,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
