import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

class OverviewView extends StatelessWidget {
  final List<_OverviewItem> items = [
    _OverviewItem(name: "当前借阅", data: 123, unit: "本"),
    _OverviewItem(name: "阅读数量", data: 123, unit: "本"),
    _OverviewItem(name: "违规记录", data: 12, unit: "次"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.w,
      color: Color(0xffaaaaaa),
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Positioned(
            bottom: -100.w,
            left: 30.w,
            right: 30.w,
            height: 300.w,
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffcccccc),
                      blurRadius: 8,
                    )
                  ]),
              child: Flex(
                direction: Axis.horizontal,
                children: items
                    .map(
                      (item) => Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              item.name,
                              style: TextStyle(
                                fontSize: 28.sp,
                                color: Color(0xff666666),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  item.data.toString(),
                                  style: TextStyle(
                                    fontSize: 56.sp,
                                  ),
                                ),
                                Text(
                                  item.unit,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    color: Color(0xff666666),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewItem {
  String name;
  int data;
  String unit;

  _OverviewItem({
    this.name,
    this.data,
    this.unit,
  });
}
