import 'dart:convert';

import 'package:bookApp/models/BorrowBookItem.dart';

enum QRCodeType {
  Unknown,
  Borrow,
  Return,
}

/// 二维码数据模型
class QRCodeData {
  QRCodeType type;
  int userId;
  String userName;
  List<BorrowBookItem> books;

  QRCodeData({
    this.type = QRCodeType.Unknown,
    this.userId,
    this.userName,
    this.books,
  });

  QRCodeData.initWithJsonString(String jsonString) {
    Map map = json.decode(jsonString);
    if (map["type"] == "borrow") {
      type = QRCodeType.Borrow;
    } else if (map["type"] == "return") {
      type = QRCodeType.Return;
    } else {
      type = QRCodeType.Unknown;
    }
    userId = map["userId"];
    userName = map["userName"];
    books = (map["books"] as List)
        .map((e) => BorrowBookItem.initWithMap(e))
        .toList();
  }

  String get jsonString {
    String typeStr = "Unknown";
    if (type == QRCodeType.Borrow) {
      typeStr = "borrow";
    } else if (type == QRCodeType.Return) {
      typeStr = "return";
    }
    return jsonEncode({
      "type": typeStr,
      "userId": userId,
      "userName": userName,
      "books": books.map<Map>((e) => e.toMap()).toList(),
    });
  }
}
