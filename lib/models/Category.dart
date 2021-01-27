/// 书籍分类模型
class BookCategory {
  int id;
  String name;
  List<BookCategory> children;

  BookCategory.initWithMap(Map map) {
    try {
      id = map["id"];
      name = map["category_name"];
      List secondCate = map["second_cate"] ?? [];
      children = secondCate.map((e) => BookCategory.initWithMap(e)).toList();
    } catch (err) {
      print("Create BookCategory Error: $err");
    }
  }
}
