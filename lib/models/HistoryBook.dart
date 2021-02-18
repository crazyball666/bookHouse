class HistoryBook {
  int id;
  String name;
  String image;
  String author;
  String category;
  int stock;

  HistoryBook({
    this.id,
    this.image,
    this.name,
    this.author,
    this.category,
    this.stock,
  });

  HistoryBook.initWithMap(Map map) {
    id = map["id"];
    name = map["name"];
    image = map["image"];
    author = map["author"];
    category = map["category"];
    stock = map["stock"];
  }

  Map toMap() {
    return {
      "id": id,
      "name": name,
      "image": image,
      "author": author,
      "category": category,
      "stock": stock,
    };
  }
}
