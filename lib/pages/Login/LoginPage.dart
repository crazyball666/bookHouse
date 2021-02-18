import 'package:bookApp/pages/Login/LoginView.dart';
import 'package:bookApp/pages/Login/RegisterView.dart';
import 'package:bookApp/util/CommonUtil.dart';
import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

class LoginPage extends StatefulWidget {
  static showLoginPage() async {
    await CommonUtil.navigatorPop(LoginPage());
  }

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showLogin = true;

  _onTapBtn() {
    setState(() {
      _showLogin = !_showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;
    double insetsBottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Listener(
        onPointerDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        behavior: HitTestBehavior.translucent,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          color: Color(0xFFFFCC55),
          height: screenH - insetsBottom,
          child: SafeArea(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: Container(
                        key: ValueKey<bool>(_showLogin),
                        width: 300,
                        decoration: BoxDecoration(
                          color: Color(0xFFFEFEFE),
                          borderRadius: BorderRadius.all(Radius.circular(10.w)),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.w, vertical: 40.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _showLogin ? LoginView() : RegisterView(),
                            Container(
                              margin: EdgeInsets.only(top: 30.w),
                              child: GestureDetector(
                                onTap: _onTapBtn,
                                child: Text(
                                  _showLogin ? "注册>>" : "已有账号>>",
                                  style: TextStyle(
                                      fontSize: 25.sp,
                                      color: Color(0xff666666)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 10,
                  child: IconButton(
                    iconSize: 48.sp,
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
