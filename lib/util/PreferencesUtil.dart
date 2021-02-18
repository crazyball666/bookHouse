import 'dart:convert';

import 'package:bookApp/models/HistoryBook.dart';
import 'package:bookApp/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _userInfoKey = "userInfo";
const String _loginInfoAccountKey = "loginInfoAccount";
const String _loginInfoPasswordKey = "loginInfoPassword";
const String _historyBookKey = "historyBook";

class PreferencesUtil {
  static Future saveUserInfo(User user) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString(_userInfoKey, jsonEncode(user.toMap()));
    } catch (err) {}
  }

  static Future removeUserInfo() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove(_userInfoKey);
    } catch (err) {}
  }

  static Future<User> getUserInfo() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String jsonInfo = preferences.getString(_userInfoKey);
      Map userInfoMap = jsonDecode(jsonInfo);
      return User.initWithMap(userInfoMap);
    } catch (err) {
      return null;
    }
  }

  static Future saveLoginInfo(String account, String password) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString(_loginInfoAccountKey, account);
      await preferences.setString(_loginInfoPasswordKey, password);
    } catch (err) {}
  }

  static Future removeLoginInfo() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove(_loginInfoAccountKey);
      await preferences.remove(_loginInfoPasswordKey);
    } catch (err) {}
  }

  static Future<List<String>> getLoginInfo() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String account = preferences.getString(_loginInfoAccountKey);
      String password = preferences.getString(_loginInfoPasswordKey);
      return [account ?? "", password ?? ""];
    } catch (err) {
      return ["", ""];
    }
  }

  static Future<List<HistoryBook>> getHistoryBookList() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      List<String> jsonList = preferences.getStringList(_historyBookKey) ?? [];
      return jsonList
          .map<HistoryBook>((e) => HistoryBook.initWithMap(json.decode(e)))
          .toList();
    } catch (err) {
      print("读取历史记录失败$err");
      return [];
    }
  }

  static addHistoryBook(HistoryBook historyBook) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      List<String> jsonList = preferences.getStringList(_historyBookKey) ?? [];
      int index = jsonList.indexWhere((jsonString) {
        try {
          HistoryBook current =
              HistoryBook.initWithMap(json.decode(jsonString));
          return current.id == historyBook.id;
        } catch (err) {
          return false;
        }
      });
      if (index < 0) {
        jsonList.insert(0, json.encode(historyBook.toMap()));
      } else {
        String item = jsonList.removeAt(index);
        jsonList.insert(0, item);
      }
      await preferences.setStringList(_historyBookKey, jsonList);
    } catch (err) {
      print("添加历史记录失败$err");
    }
  }
}
