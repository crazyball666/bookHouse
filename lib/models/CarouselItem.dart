import 'package:bookApp/util/CommonUtil.dart';

/// 轮播图模型
class CarouselItem {
  String image;
  int bookId;

  CarouselItem.initWithMap(Map map) {
    try {
      image = "${CommonUtil.imageHost}${map["image"]}";
      bookId = map["book_id"];
    } catch (err) {
      print("Create CarouseItem Error: $err");
    }
  }
}
