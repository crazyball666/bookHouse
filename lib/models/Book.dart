import 'package:bookApp/models/Category.dart';
import 'package:bookApp/util/CommonUtil.dart';

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
  String firstCate;
  String secondCate;

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
      isCollect = (map["is_collect"] ?? 0) > 0;
      isBorrow = (map["is_borrow"] ?? 0) > 0;
      firstCategory = BookCategory.initWithMap(map["firstCate"] ?? {});
      secondCategory = BookCategory.initWithMap(map["secondCate"] ?? {});
      firstCate = map["first_cate"];
      secondCate = map["second_cate"];
    } catch (err) {
      print("Create Book Error: $err");
    }
  }

  Book.mock() {
    name = "大傻逼";
  }
}
