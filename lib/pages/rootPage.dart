import 'dart:async';

import 'package:bookApp/models/User.dart';
import 'package:bookApp/network/ApiRequest.dart';
import 'package:bookApp/pages/Category/CategoryPage.dart';
import 'package:bookApp/pages/Index/IndexPage.dart';
import 'package:bookApp/pages/Login/LoginPage.dart';
import 'package:bookApp/pages/Mine/MinePage.dart';
import 'package:bookApp/pages/MyRead/MyReadPage.dart';
import 'package:bookApp/provider/UserProvider.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:bookApp/util/PreferencesUtil.dart';
import 'package:bookApp/util/ScreenUtil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppRootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppRootPageState();
}

class AppRootPageState extends State<AppRootPage> {
  List<Widget> _pages = [];
  PageController _pageController = PageController();
  bool _hasInit = false;
  ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  StreamSubscription _logoutSub;

  /// 切换tab
  _onTapBottomNavigationItem(int index) async {
    bool isLogin = Provider.of<UserProvider>(context, listen: false).isLogin;
    if (!isLogin && (index == 2 || index == 3)) {
      await LoginPage.showLoginPage();
      if (!Provider.of<UserProvider>(context, listen: false).isLogin) {
        return;
      }
    }
    _pageController.jumpToPage(index);
    _currentIndex.value = index;
  }

  /// 获取登录状态
  _getLoginStatus() async {
    try {
      List<String> loginInfo = await PreferencesUtil.getLoginInfo();
      if (loginInfo.length == 2 &&
          loginInfo[0].isNotEmpty &&
          loginInfo[1].isNotEmpty) {
        User user = await ApiRequest().login(loginInfo[0], loginInfo[1]);
        if (user.id != null && user.id > 0) {
          Provider.of<UserProvider>(context, listen: false).loginUser(user);
        }
      }
    } catch (err) {
      print("初始化登录失败");
    }
  }

  /// 登出监听
  _onLogout(dynamic event) {
    if (_currentIndex.value > 1) {
      _pageController.jumpToPage(0);
      _currentIndex.value = 0;
    }
  }

  @override
  void initState() {
    super.initState();
    CommonUtil.rootContext = context;
    _logoutSub = CommonUtil.logoutBroadcast.stream.listen(_onLogout);

    _pages = [
      IndexPage(
        onTapAllCategory: () => _onTapBottomNavigationItem(1),
      ),
      CategoryPage(),
      MyReadPage(),
      MinePage(),
    ];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ScreenUtil.init(context, designSize: Size(750, 1334));
      await ApiRequest().getApiHost();
      await _getLoginStatus();
      setState(() {
        _hasInit = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _logoutSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasInit) {
      return Container(
        color: Colors.white,
      );
    }
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: _currentIndex,
        builder: (context, snapshot, child) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: _onTapBottomNavigationItem,
            selectedItemColor: Colors.orange,
            unselectedItemColor: Color(0xff999999),
            showUnselectedLabels: true,
            currentIndex: _currentIndex.value,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
              BottomNavigationBarItem(icon: Icon(Icons.book), label: '书籍分类'),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: '我的阅读'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
            ],
          );
        },
      ),
    );
  }
}
