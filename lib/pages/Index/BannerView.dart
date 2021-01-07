import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

/// Banner图组件
class BannerView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 300.w,
        color: Colors.yellow,
      ),
    );
  }
}
