import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/widgets/read_widgets/word_button_widget.dart';

Widget wordsWidget({
  required int wordsScrollFlex,
  required List<String> words,
  required ScrollController scrollController,
  required String originalSingleSentence,
}) {
  return Flexible(
    flex: wordsScrollFlex,
    child: Container(
      width: AppLingua.width,
      height: AppLingua.height * 0.08,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: originalSingleSentence.isNotEmpty
              ? [
                  for (int i = 0; i < words.length; i++)
                    WordButtonWidget(
                      inButtonText: words[i],
                    ),
                ]
              : [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                  ),
                ],
        ),
      ),
    ),
  );
}
