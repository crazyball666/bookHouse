/// 借阅书籍模型
class BorrowBookItem {
  int recordId;
  int bookId;
  String name;
  String author;
  String image;
  String category;
  DateTime startTime;
  DateTime endTime;

  BorrowBookItem({
    this.recordId,
    this.bookId,
    this.name,
    this.author,
    this.image,
    this.category,
    this.startTime,
    this.endTime,
  });

  Map toMap() {
    return {
      "recordId": recordId,
      "bookId": bookId,
      "name": name,
      "author": author,
      "image": image,
      "category": category,
      "startTime": startTime.millisecondsSinceEpoch,
      "endTime": endTime.millisecondsSinceEpoch,
    };
  }

  BorrowBookItem.initWithMap(Map map) {
    recordId = map["recordId"];
    bookId = map["bookId"];
    name = map["name"];
    author = map["author"];
    image = map["image"];
    category = map["category"];
    startTime = DateTime.fromMillisecondsSinceEpoch(map["startTime"]);
    endTime = DateTime.fromMillisecondsSinceEpoch(map["endTime"]);
  }
}
