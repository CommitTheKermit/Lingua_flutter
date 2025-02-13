import 'package:flutter/material.dart';

/// 문자 단어별 자동 줄 바꿈
class WrapText extends StatefulWidget {
  const WrapText(
      this.text, {
        super.key,
        this.align,
        this.style,
        /* 텍스트 */
      });

  final String text;
  final WrapAlignment? align;
  final TextStyle? style;

  @override
  State<StatefulWidget> createState() => _WrapTextState();
}

class _WrapTextState extends State<WrapText> with TickerProviderStateMixin {
  var textList = [];

  @override
  void initState() {
    var tempList = widget.text.split('\n');

    textList = List.generate(tempList.length, (index) => tempList[index].split(' '));

    super.initState();
  }

  @override
  void didUpdateWidget(covariant WrapText oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: (widget.align == null || widget.align == WrapAlignment.center) ? CrossAxisAlignment.center : (widget.align == WrapAlignment.start ? CrossAxisAlignment.start : CrossAxisAlignment.end),
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var tempList in textList)
          Wrap(
            alignment: widget.align ?? WrapAlignment.center,
//      runSpacing: 4,
            spacing: 4,
            children: [
              for (var text in tempList)
                Text(
                  text,
                  style: widget.style,
                )
            ],
          )
      ],
    );
  }
}
