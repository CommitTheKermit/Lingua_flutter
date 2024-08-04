import 'package:flutter/material.dart';
import 'package:lingua/main/main_theme.dart';

///일반적 형식의 텍스트 위젯
Text comnText({
  required String labelText,
  double? fontSize,
  Color? fontColor,
  FontWeight? fontWeight = FontWeight.w600,
  TextAlign? textAlign = TextAlign.center,
  TextOverflow? textOverflow,
  double? fontHeight,
  double? letterSpacing,
}) {
  return Text(
    labelText,
    textAlign: textAlign,
    textScaler: TextScaler.noScaling,
    overflow: textOverflow,
    style: TextStyle(
      color: fontColor ?? MAIN_TEXT_COLOR,
      fontSize: fontSize ?? 12,
      fontWeight: fontWeight,
      height: fontHeight,
      letterSpacing: letterSpacing,
    ),
  );
}
