import 'package:intl/intl.dart';

///借阅车书籍模型
class BorrowCarBook {
  int id;
  int userId;
  int bookId;
  DateTime createTime;
  String bookName;
  String bookAuthor;
  String bookImage;
  String bookFirstCate;
  String bookStock;
  String bookPlace;

  BorrowCarBook.initWithMap(Map map) {
    try {
      id = map["id"];
      userId = map["user_id"];
      bookId = map["book_id"];
      if (map["create_time"] != null) {
        createTime =
            DateFormat('yyyy-MM-dd HH:mm:ss').parse(map["create_time"]);
      }
      bookName = map["book_name"];
      bookAuthor = map["book_author"];
      bookImage = map["book_image"];
      bookFirstCate = map["book_first_cate"];
      bookStock = map["book_stock"];
      bookPlace = map["book_place"];
    } catch (err) {
      print("Create Book Error: $err");
    }
  }
}
