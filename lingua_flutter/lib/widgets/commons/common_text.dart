import 'package:flutter/material.dart';

Text commonText({
  required String labelText,
  double? fontSize,
  Color? fontColor,
  FontWeight? fontWeight = FontWeight.w600,
}) {
  return Text(
    labelText,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: fontColor ?? const Color(0xFF363639),
      fontSize: fontSize ?? 12,
      fontWeight: fontWeight,
    ),
  );
}
