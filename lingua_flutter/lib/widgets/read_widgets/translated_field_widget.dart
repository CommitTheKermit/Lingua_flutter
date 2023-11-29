import 'package:flutter/material.dart';
import 'package:lingua/models/read_option.dart';

class TranslatedFieldWidget extends StatefulWidget {
  final String argText;
  final ReadOption readOption;

  const TranslatedFieldWidget({
    super.key,
    required this.argText,
    required this.readOption,
  });

  @override
  State<TranslatedFieldWidget> createState() => _TranslatedFieldWidgetState();
}

class _TranslatedFieldWidgetState extends State<TranslatedFieldWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(TranslatedFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.argText != oldWidget.argText) {
      _scrollController.jumpTo(0); // 스크롤 위치 초기화
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: Color(widget.readOption.optBackgroundColor),
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
    );
  }
}
