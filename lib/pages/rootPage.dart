import 'package:bookApp/pages/Category/CategoryPage.dart';
import 'package:bookApp/pages/Index/IndexPage.dart';
import 'package:bookApp/pages/Login/LoginPage.dart';
import 'package:bookApp/pages/MyRead/MyReadPage.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:bookApp/util/ScreenUtil.dart';
import 'package:flutter/material.dart';

class AppRootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppRootPageState();
}

class AppRootPageState extends State<AppRootPage> {
  PageController _pageController = PageController();
  bool _hasInit = false;
  ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  _onTapBottomNavigationItem(int index) {
    // if (index == 2 || index == 3) {
    //   LoginPage.showLoginPage();
    //   return;
    // }
    _pageController.jumpToPage(index);
    _currentIndex.value = index;
  }

  @override
  void initState() {
    super.initState();
    CommonUtil.rootContext = context;
    Future.delayed(Duration()).then((_) {
      ScreenUtil.init(context, designSize: Size(750, 1334));
      setState(() {
        _hasInit = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasInit) {
      return Container();
    }
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          IndexPage(),
          CategoryPage(),
          MyReadPage(),
          Container(),
        ],
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
