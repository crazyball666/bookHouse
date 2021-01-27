import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

class RegisterView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _loading = false;

  TextEditingController _accountController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  _onTapRegister() {
    setState(() {
      _loading = true;
    });
    Future.delayed(Duration(milliseconds: 2000)).then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(3, (index) {
          return Container(
            color: Colors.white,
            margin: EdgeInsets.only(bottom: 40.w),
            child: TextField(
              obscureText: index == 0 ? false : true,
              style: TextStyle(fontSize: 26.sp),
              controller: index == 0
                  ? _accountController
                  : index == 1
                      ? _passwordController
                      : _confirmPasswordController,
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.w,
                  ),
                ),
                hintText: index == 0
                    ? "请输入用户名"
                    : index == 1
                        ? "请输入密码"
                        : "请再次输入密码",
              ),
            ),
          );
        }),
        MaterialButton(
          height: 80.w,
          minWidth: double.maxFinite,
          color: Colors.blue,
          disabledColor: Colors.blue,
          onPressed: _loading ? null : _onTapRegister,
          child: _loading
              ? SizedBox(
                  width: 30.w,
                  height: 30.w,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white70,
                    strokeWidth: 3.w,
                  ),
                )
              : Text(
                  "注册",
                  style: TextStyle(color: Colors.white, fontSize: 26.sp),
                ),
        ),
      ],
    );
  }
}
