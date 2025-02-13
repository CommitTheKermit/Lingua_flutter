import 'package:flutter/material.dart';
import 'package:lingua/models/read_option.dart';
import 'package:lingua/widgets/commons/common.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TextFieldWidget extends StatefulWidget {
  final int flexValue;
  final String argText;
  final ReadOption readOption;
  final int currentIndex;
  final int endIndex;

  const TextFieldWidget({
    super.key,
    required this.flexValue,
    required this.argText,
    required this.readOption,
    this.currentIndex = 0,
    this.endIndex = 0,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(TextFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.argText != oldWidget.argText) {
      _scrollController.jumpTo(0); // 스크롤 위치 초기화
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      flex: widget.flexValue,
      child: Container(
        width: 100.w,
        decoration: BoxDecoration(
          color: Color(widget.readOption.optBackgroundColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 4.w,
                    top: 1.h,
                  ),
                  child: comnText(
                     '원문',
                    fontSize:2.h,
                    colorFont: const Color(0xFF868E96),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 4.w,
                    top: 1.h,
                  ),
                  child: comnText(
                       '${widget.currentIndex}/${widget.endIndex}',
                      fontSize:2.h,
                      colorFont: const Color(0xFF1E4A75)),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 1.h,
                    horizontal: 2.w,
                  ),
                  child: Text(
                    widget.argText,
                    style: TextStyle(
                      fontSize: widget.readOption.optfontSize,
                      height: widget.readOption.optFontHeight,
                      color: Color(widget.readOption.optcolorFont),
                      fontFamily: widget.readOption.optFontFamily,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
