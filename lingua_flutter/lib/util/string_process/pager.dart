import 'dart:ui';

import 'package:flutter/material.dart';

// List<String> paginateText({
//   required String text,
//   required TextStyle style,
//   required Size screenSize,
// }) {
//   final TextPainter textPainter = TextPainter(
//     text: TextSpan(
//       text: text,
//       style: style,
//     ),
//     textDirection: TextDirection.ltr,
//     maxLines: screenSize.height * 0.7 ~/ style.fontSize!,
//   );

//   List<String> pages = [];
//   int start = 0;

//   while (start < text.length) {
//     textPainter.text = TextSpan(text: text, style: style);
//     textPainter.layout(maxWidth: screenSize.width);

//     final int end = textPainter
//         .getPositionForOffset(Offset(screenSize.width, screenSize.height))
//         .offset;

//     pages.add(text.substring(0, start + end));
//     // log(pages.last);

//     // start += end;
//     text = text.substring(end);
//     // log(end.toString());
//     log(textPainter.size.width.toString());
//     log(textPainter.size.height.toString());
//   }

//   // log(pages.length.toString());
//   // log(FileProcess.stringContents.length.toString());
//   return pages;
// }

List<String> paginateText({
  required String text,
  required TextStyle style,
  required Size screenSize,
}) {
  List<String> pages = [];
  List<int> lengths = [];

  screenSize = Size(screenSize.width * 0.9, screenSize.height * 0.87);

  final textSpan = TextSpan(
    text: text,
    style: style,
  );
  final textPainter = TextPainter(
    text: textSpan,
    textDirection: TextDirection.ltr,
  );
  textPainter.layout(minWidth: 0, maxWidth: screenSize.width);

  // https://medium.com/swlh/flutter-line-metrics-fd98ab180a64
  List<LineMetrics> lines = textPainter.computeLineMetrics();
  double currentPageBottom = screenSize.height;
  int currentPageStartIndex = 0;
  int currentPageEndIndex = 0;

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];

    final left = line.left;
    final top = line.baseline - line.ascent;
    final bottom = line.baseline + line.descent;

    // Current line overflow page
    if (currentPageBottom < bottom) {
      currentPageEndIndex =
          textPainter.getPositionForOffset(Offset(left, top)).offset;
      final pageText =
          text.substring(currentPageStartIndex, currentPageEndIndex);
      pages.add(pageText);

      currentPageStartIndex = currentPageEndIndex;
      currentPageBottom = top + screenSize.height;
      // dev.log(pageText);
      // log(pageText.length.toString());
      // lengths.add(pageText.length);
    }
  }

  final lastPageText = text.substring(currentPageStartIndex);
  pages.add(lastPageText);

  // dev.log(lengths.fold(0, max).toString());
  // dev.log(lengths.indexOf(lengths.fold(0, max)).toString());

  return pages;
}
