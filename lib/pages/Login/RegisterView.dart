import 'package:bookApp/components/Toast.dart';
import 'package:bookApp/network/ApiRequest.dart';
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

  _onTapRegister() async {
    setState(() {
      _loading = true;
    });
    String account = _accountController.text;
    String password = _passwordController.text;
    String confirmPass = _confirmPasswordController.text;
    if (account.isEmpty || password.isEmpty || confirmPass.isEmpty) {
      CBToast.showErrorToast(context, "账号密码不能为空");
      return;
    }
    if (password != confirmPass) {
      CBToast.showErrorToast(context, "两次密码不一致");
      return;
    }
    try {
      await ApiRequest().register(account, password);
    } catch (err) {}
    setState(() {
      _loading = false;
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
