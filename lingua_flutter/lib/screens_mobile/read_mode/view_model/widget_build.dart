import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/screens_mobile/read_mode/view_model/read_mode_prov.dart';

extension ReadModeWidgetBuild on ReadModeProv {
  List<TextSpan> buildTextSpans() {
    List<TextSpan> spans = [];

    // final RegExp wordRegExp = RegExp(r'(\s+|\S+)'); // 단어 또는 공백 단위로 분리
    // final RegExp sentenceRegExp = RegExp(
    //   r'(?<=[.!?。？！])\s+(?=[A-Z가-힣0-9“‘])',
    //   multiLine: true,
    // );
    // final sentenceRegExp = RegExp(r'[^.!?]+[.!?]+', multiLine: true);

    final sentenceRegExp = RegExp(
      r'(?<=[.!?。？！])[\s\n]+(?=[^\s])|[\r\n]+',
    );

    String targetPage = model.pages[model.index.toInt()];

    final matches =
        targetPage.split(sentenceRegExp).map((s) => s.trim()).toList();
    for (final match in matches) {
      final String token = match;

      if (token.trim().isEmpty) {
        // 공백 또는 줄바꿈은 그대로 출력
        spans.add(TextSpan(text: token));
      } else {
        spans.add(
          TextSpan(
            style: model.readTextStyle,
            text: token,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                ScaffoldMessenger.of(globalContext).showSnackBar(
                  SnackBar(content: Text('단어 선택: $token')),
                );
              },
          ),
        );
      }
    }

    return spans;
  }
}
