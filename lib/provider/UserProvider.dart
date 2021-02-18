import 'package:bookApp/models/User.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:bookApp/util/PreferencesUtil.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User user;

  bool get isLogin => user != null;

  Future loginUser(User u) async {
    user = u;
    notifyListeners();
    await PreferencesUtil.saveUserInfo(u);
  }

  Future registerUser() async {
    user = null;
    notifyListeners();
    await PreferencesUtil.removeUserInfo();
    CommonUtil.logoutBroadcast.sink.add(null);
  }
}
