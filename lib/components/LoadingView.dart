import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xcc666666),
      alignment: Alignment.center,
      child: Container(
        width: 200.w,
        height: 200.w,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(16.w),
        ),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        ),
      ),
    );
  }
}
