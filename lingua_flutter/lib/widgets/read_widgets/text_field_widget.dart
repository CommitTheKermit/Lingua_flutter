import 'package:flutter/material.dart';
import 'package:lingua/models/read_option.dart';

class TextFieldWidget extends StatefulWidget {
  final int flexValue;
  final String argText;
  final ReadOption readOption;

  const TextFieldWidget({
    super.key,
    required this.flexValue,
    required this.argText,
    required this.readOption,
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
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
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
    );
  }
}
