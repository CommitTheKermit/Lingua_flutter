import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final int flexValue;
  final Color tempColor;
  final String argText;

  const TextFieldWidget({
    super.key,
    required this.flexValue,
    required this.tempColor,
    required this.argText,
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
          color: widget.tempColor,
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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              widget.argText,
              style: const TextStyle(fontSize: 25),
            ),
          ),
        ),
      ),
    );
  }
}
