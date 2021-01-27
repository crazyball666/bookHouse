import 'package:flutter/material.dart';
import 'package:bookApp/util/ScreenUtil.dart';

class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(String) onSearch;
  final FocusNode focusNode;
  final Color color;
  final Color inputColor;

  SearchBar({
    this.onSearch,
    this.focusNode,
    this.color = Colors.blue,
    this.inputColor = Colors.white,
  });

  @override
  Size get preferredSize => Size.fromHeight(120.w);

  @override
  State<StatefulWidget> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _textEditingController = TextEditingController();

  void _onSearch(String text) {
    if (widget.onSearch != null) {
      widget.onSearch(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: Stack(
        children: [
          Positioned(
            left: 15.w,
            right: 15.w,
            bottom: 20.w,
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 26.w),
                      decoration: BoxDecoration(
                        // border: Border.all(color: Color(0xFF333333), width: 1.w),
                        borderRadius: BorderRadius.circular(50.w),
                        color: widget.inputColor,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Color(0xFF333333),
                            size: 38.sp,
                          ),
                          Expanded(
                            child: TextField(
                              controller: _textEditingController,
                              focusNode: widget.focusNode,
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                              ),
                              onSubmitted: _onSearch,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => _onSearch(_textEditingController.text),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.w, horizontal: 16.w),
                      child: Text(
                        "搜索",
                        style: TextStyle(
                            fontSize: 30.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
