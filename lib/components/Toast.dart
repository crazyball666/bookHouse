import 'dart:async';
import 'package:bookApp/util/ScreenUtil.dart';
import 'package:flutter/material.dart';

/// Toast组件
class CBToast {
  static List<GlobalKey<EFToastState>> _keyList = [];

  static showToast(
    BuildContext context, {
    Icon icon,
    String text,
    Color color = Colors.black,
    Color textColor = Colors.white,
    Duration toastDuration = const Duration(seconds: 2),
  }) {
    var key = GlobalKey<EFToastState>();
    EFToast toast = EFToast(
      key: key,
      icon: icon,
      text: text,
      color: color,
      textColor: textColor,
    );
    OverlayEntry entry = OverlayEntry(builder: (context) => toast);
    toast.didShow = (EFToastState state, double y) {
      _keyList.add(key);
      _keyList.forEach((key) {
        if (state == key.currentState) return;
        key.currentState.moveDown(y + 20.h);
      });
    };
    toast.didDismiss = (EFToastState state, double y) {
      _keyList.remove(key);
      entry.remove();
    };
    Overlay.of(context).insert(entry);
  }

  static showSuccessToast(BuildContext context, String text) {
    showToast(
      context,
      icon: Icon(
        Icons.check,
        color: Colors.white,
        size: 36.sp,
      ),
      text: text,
      color: Color(0xFF00CC76),
    );
  }

  static showErrorToast(BuildContext context, String text) {
    showToast(
      context,
      icon: Icon(
        Icons.error,
        color: Colors.white,
        size: 36.sp,
      ),
      text: text,
      color: Colors.redAccent,
    );
  }
}

class EFToast extends StatefulWidget {
  Key key;
  Icon icon;
  String text;
  Color color;
  Color textColor;
  Duration toastDuration;
  Function(EFToastState state, double height) didShow;
  Function(EFToastState state, double height) didDismiss;

  EFToast({
    this.key,
    this.icon,
    this.text,
    this.color = Colors.black,
    this.textColor = Colors.white,
    this.toastDuration = const Duration(seconds: 2),
    this.didShow,
    this.didDismiss,
  });

  @override
  State<StatefulWidget> createState() => EFToastState();
}

class EFToastState extends State<EFToast> {
  int _status = 0; //0初始化 1显示过渡中 2显示中 3消失过渡中 4消失完成
  double _opacity = 0;
  double _positionY = 100.h;
  Duration _duration = Duration(milliseconds: 300);

  void moveDown(double y) {
    setState(() {
      _positionY += y;
    });
  }

  void _animatedEnd() {
    if (_status == 1) {
      _status = 2;
      Future.delayed(widget.toastDuration).then((value) {
        _status = 3;
        setState(() {
          _opacity = 0;
          _positionY += 30.h;
        });
      });
    } else if (_status == 3) {
      _status = 4;
      if (widget.didDismiss != null) {
        widget.didDismiss(this, context.size.height);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.didShow(this, context.size.height);
      _status = 1;
      setState(() {
        _opacity = 1;
        _positionY += 30.h;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: _duration,
      left: 48.w,
      right: 48.w,
      top: _positionY,
      onEnd: _animatedEnd,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: _duration,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 18.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.w),
                color: widget.color,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.icon != null ? widget.icon : SizedBox(),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: Text(
                      widget.text ?? "",
                      softWrap: true,
                      overflow: TextOverflow.clip,
                      style:
                          TextStyle(color: widget.textColor, fontSize: 28.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
