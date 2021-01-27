import 'package:bookApp/models/Category.dart';

/// 书籍模型
class Book {
  int id;
  String name;
  String author;
  int firstCategoryId;
  int secondCategoryId;
  int total;
  int stock;
  String bookCode;
  int status;
  String place;
  String introduction;
  String image;
  int readCount;
  int collectCount;
  double scoreAvg;
  bool isCollect;
  bool isBorrow;
  BookCategory firstCategory;
  BookCategory secondCategory;

  Book.initWithMap(Map map) {
    try {
      id = map["id"];
      name = map["book_name"];
      author = map["author"];
      firstCategoryId = map["first_category_id"];
      secondCategoryId = map["second_category_id"];
      total = map["total"];
      stock = map["stock"];
      bookCode = map["book_code"];
      status = map["status"];
      place = map["place"];
      introduction = map["introduction"];
      image = map["image"];
      readCount = map["readCount"] ?? 0;
      collectCount = map["collectCount"] ?? 0;
      scoreAvg = map["scoreAvg"] ?? 0.0;
      isCollect = map["is_collect"] == 1;
      isBorrow = map["is_borrow"] == 1;
      firstCategory = BookCategory.initWithMap(map["firstCate"] ?? {});
      secondCategory = BookCategory.initWithMap(map["secondCate"] ?? {});
    } catch (err) {
      print("Create Book Error: $err");
    }
  }
}
