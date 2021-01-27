import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

class LoginView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _loadingLogin = false;

  TextEditingController _accountController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  _onTapLogin() {
    setState(() {
      _loadingLogin = true;
    });
    Future.delayed(Duration(milliseconds: 2000)).then((value) {
      setState(() {
        _loadingLogin = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(2, (index) {
          return Container(
            color: Colors.white,
            margin: EdgeInsets.only(bottom: 40.w),
            child: TextField(
              obscureText: index == 0 ? false : true,
              style: TextStyle(fontSize: 26.sp),
              controller: index == 0 ? _accountController : _passwordController,
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.w,
                  ),
                ),
                hintText: index == 0 ? "请输入用户名" : "请输入密码",
              ),
            ),
          );
        }),
        MaterialButton(
          height: 80.w,
          minWidth: double.maxFinite,
          color: Colors.blue,
          disabledColor: Colors.blue,
          onPressed: _loadingLogin ? null : _onTapLogin,
          child: _loadingLogin
              ? SizedBox(
                  width: 30.w,
                  height: 30.w,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white70,
                    strokeWidth: 3.w,
                  ),
                )
              : Text(
                  "登录",
                  style: TextStyle(color: Colors.white, fontSize: 26.sp),
                ),
        ),
      ],
    );
  }
}
