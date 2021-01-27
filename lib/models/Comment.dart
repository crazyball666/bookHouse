import 'package:bookApp/models/User.dart';
import 'package:intl/intl.dart';

/// 评论模型
class Comment {
  int id;
  int bookId;
  int userId;
  int score;
  String content;
  DateTime createTime;
  String userAvatar;
  String userName;

  Comment.initWithMap(Map map) {
    try {
      id = map["id"];
      bookId = map["book_id"];
      userId = map["user_id"];
      score = map["score"];
      content = map["content"];
      if (map["create_time"] != null) {
        createTime =
            DateFormat('yyyy-MM-dd HH:mm:ss').parse(map["create_time"]);
      }
      userAvatar = map["user_avatar"];
      userName = map["user_name"];
    } catch (err) {
      print("Create Comment Error: $err");
    }
  }
}
