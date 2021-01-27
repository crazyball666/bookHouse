class User {
  int id;
  String name;
  int managerId;
  int auth;

  User.initWithMap(Map map) {
    try {
      id = map["id"];
      name = map["name"];
      managerId = map["manager_id"];
      auth = map["auth"];
    } catch (err) {
      print("Create User Error: $err");
    }
  }
}
