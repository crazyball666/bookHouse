import 'package:bookApp/components/CacheImageView.dart';
import 'package:bookApp/components/Toast.dart';
import 'package:bookApp/models/User.dart';
import 'package:bookApp/pages/BookCollect/BookCollectPage.dart';
import 'package:bookApp/pages/BookComment/BookCommentPage.dart';
import 'package:bookApp/pages/BorrowCarPage/BorrowCarPage.dart';
import 'package:bookApp/pages/BorrowRulePage/BorrowRulePage.dart';
import 'package:bookApp/pages/BrowsingHistory/BrowsingHistoryPage.dart';
import 'package:bookApp/provider/UserProvider.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:bookApp/util/PreferencesUtil.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';
import 'package:provider/provider.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  List<_MenuItem> _menuItems = [
    _MenuItem(
        name: "借阅车",
        icon: Icon(
          Icons.car_repair,
          size: 64.w,
          color: Colors.red,
        )),
    _MenuItem(
        name: "图书评论",
        icon: Icon(
          Icons.comment,
          size: 64.w,
          color: Colors.yellow,
        )),
    _MenuItem(
        name: "我的收藏",
        icon: Icon(
          Icons.star,
          size: 64.w,
          color: Colors.orange,
        )),
    _MenuItem(
        name: "浏览记录",
        icon: Icon(
          Icons.remove_red_eye,
          size: 64.w,
          color: Colors.pink,
        )),
  ];

  /// 登出
  _logout() async {
    await PreferencesUtil.removeLoginInfo();
    await Provider.of<UserProvider>(context, listen: false).registerUser();
    CBToast.showSuccessToast(CommonUtil.rootContext, "登出成功");
  }

  /// 编辑个人资料
  _editPersonInfo() {}

  /// 借阅规则
  _readBorrowRule() {
    CommonUtil.navigatorPush(BorrowRulePage());
  }

  /// 选择菜单
  _onTapMenuItem(int index) {
    Widget page;
    if (index == 0) {
      page = BorrowCarPage();
    } else if (index == 1) {
      page = BookCommentPage();
    } else if (index == 2) {
      page = BookCollectPage();
    } else {
      page = BrowsingHistoryPage();
    }
    CommonUtil.navigatorPush(page);
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 80.w, vertical: 60.w),
                color: Colors.blue,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          child: CacheImageView(
                            url: "${CommonUtil.baseHost}${user?.avatar}",
                            fit: BoxFit.fill,
                          ),
                          width: 150.w,
                          height: 150.w,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(75.w),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            user?.name ?? "未命名",
                            style: TextStyle(
                              fontSize: 36.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _editPersonInfo,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5.w, horizontal: 10.w),
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffeeeeee)),
                              borderRadius: BorderRadius.circular(10.w),
                            ),
                            child: Text(
                              "编辑个人资料",
                              style: TextStyle(
                                  fontSize: 24.sp, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 30.w),
                          padding: EdgeInsets.symmetric(horizontal: 30.w),
                          height: 240.w,
                          decoration: BoxDecoration(
                            color: Color(0xffEEDC82),
                            borderRadius: BorderRadius.circular(16.w),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "读者证",
                                style: TextStyle(
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "ID: ${user?.id}",
                                style: TextStyle(
                                  fontSize: 24.sp,
                                ),
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "可借阅书籍",
                                        style: TextStyle(
                                          fontSize: 22.sp,
                                        ),
                                      ),
                                      Text("${user?.gender}本"),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 30.w,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "状态",
                                        style: TextStyle(
                                          fontSize: 22.sp,
                                        ),
                                      ),
                                      Text(
                                          "${user?.auth == 1 ? "正常" : "违规"}"),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          top: 50.w,
                          right: 20.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.w, horizontal: 18.w),
                            child: Text(
                              "已通过认证",
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: Colors.white,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(20.w),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20.w,
                          right: 20.w,
                          child: GestureDetector(
                            onTap: _readBorrowRule,
                            child: Text(
                              "借阅规则",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 24.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 50.w,
                top: 40.w,
                child: GestureDetector(
                  onTap: _logout,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.w),
                    child: Text(
                      "登出",
                      style: TextStyle(color: Colors.white, fontSize: 26.sp),
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(30.w),
                  child: Text(
                    "功能应用",
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: _menuItems.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _onTapMenuItem(index),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.w),
                            child: _menuItems[index].icon,
                          ),
                          Text(_menuItems[index].name),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _MenuItem {
  String name;
  Icon icon;

  _MenuItem({this.name, this.icon});
}
