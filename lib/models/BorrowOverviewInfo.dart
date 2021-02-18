/// 借阅汇总信息
class BorrowOverviewInfo {
  int now;
  int history;
  int violation;
  List<BorrowBookCategoryInfo> bookCategoryInfoList;

  BorrowOverviewInfo.initWithMap(Map map) {
    try {
      now = map["now"];
      history = map["history"];
      violation = map["violation"];
      List list = map["count"];
      bookCategoryInfoList =
          list.map((e) => BorrowBookCategoryInfo.initWithMap(e)).toList();
    } catch (err) {
      print("Create BorrowOverviewInfo Error: $err");
    }
  }
}

/// 借阅分类信息
class BorrowBookCategoryInfo {
  String categoryName;
  int count;

  BorrowBookCategoryInfo.initWithMap(Map map) {
    try {
      categoryName = map["category_name"];
      count = map["count"];
    } catch (err) {
      print("Create BorrowBookCategoryInfo Error: $err");
    }
  }
}
