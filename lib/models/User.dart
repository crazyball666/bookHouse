class User {
  int id;
  String name;
  int gender;
  String phone;
  int status;
  int auth;
  int managerId;
  String avatar;

  User.initWithMap(Map map) {
    try {
      id = map["id"];
      name = map["name"];
      gender = map["gender"];
      phone = map["phone"];
      status = map["status"];
      auth = map["auth"];
      managerId = map["manager_id"];
      avatar = map["avatar"];
    } catch (err) {
      print("Create User Error: $err");
    }
  }

  Map toMap() {
    return {
      "id": id,
      "name": name,
      "gender": gender,
      "phone": phone,
      "status": status,
      "auth": auth,
      "manager_id": managerId,
      "avatar": avatar,
    };
  }
}
