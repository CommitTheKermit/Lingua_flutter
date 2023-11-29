import 'package:flutter/material.dart';
import 'package:lingua/models/read_option.dart';
import 'package:lingua/widgets/commons/common_text.dart';

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
        width: MediaQuery.of(context).size.width,
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
                    left: MediaQuery.of(context).size.width * 0.04,
                    top: MediaQuery.of(context).size.height * 0.01,
                  ),
                  child: commonText(
                    labelText: '원문',
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    fontColor: const Color(0xFF868E96),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.04,
                    top: MediaQuery.of(context).size.height * 0.01,
                  ),
                  child: commonText(
                      labelText: '${widget.currentIndex}/${widget.endIndex}',
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      fontColor: const Color(0xFF1E4A75)),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.01,
                    horizontal: MediaQuery.of(context).size.width * 0.02,
                  ),
                  child: Text(
                    widget.argText,
                    style: TextStyle(
                      fontSize: widget.readOption.optFontSize,
                      height: widget.readOption.optFontHeight,
                      color: Color(widget.readOption.optFontColor),
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
