
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lingua/main/main_theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

///로딩 서클
Widget comnLoading() {
  return const Center(
    child: CircularProgressIndicator(
      color: MAIN_APP_COLOR,
    ),
  );
}

///일반적 형식의 텍스트 위젯
Text comnText(
    String text, {
      double? fontSize,
      Color? colorFont,
      FontWeight? weightFont = FontWeight.w600,
      TextAlign? alignText = TextAlign.center,
      TextOverflow? overflowText,
      double? heightText,
      double? letterSpacing,
      TextDecoration? decoration,
    }) {
  return Text(
    text,
    textAlign: alignText,
    textScaler: TextScaler.noScaling,
    overflow: overflowText,
    style: TextStyle(
      color: colorFont,
      fontSize: fontSize ?? 13,
      fontWeight: weightFont,
      height: heightText,
      letterSpacing: letterSpacing,
      decoration: decoration,
    ),
  );
}

Container comnDivider({double? thickness, Color? color}) {
  return Container(
    height: thickness ?? 1,
    width: 100.w,
    color: color ?? const Color(0xffe5e5e5),
  );
}

// Divider commonDivider() {
//   return Divider(
//     color: Colors.transparent,
//     thickness: AppLingua.height * 0.005,
//     height: AppLingua.height * 0.005,
//   );
// }


Text comnCustomIcon(
    IconData icon, {
      double? size,
      Color? color,
      FontWeight? weight = FontWeight.w600,
    }) {
  return Text(
    String.fromCharCode(icon.codePoint),
    style: TextStyle(
      inherit: false,
      color: color,
      fontSize: size,
      fontWeight: weight,
      fontFamily: icon.fontFamily,
      package: icon.fontPackage,
    ),
  );
}

Text comnTextRich(
    InlineSpan textSpan, {
      TextOverflow? overflow,
      TextStyle? style,
      TextAlign? textAlign,
      int? maxLines,
    }) {
  return Text.rich(
    textSpan,
    textScaler: TextScaler.noScaling,
    overflow: overflow,
    style: style,
    textAlign: textAlign,
    maxLines: maxLines,
  );
}
