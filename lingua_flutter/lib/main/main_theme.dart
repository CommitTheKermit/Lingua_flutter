// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const Color MAIN_APP_COLOR = Color(0xFF1E4A75);
const Color MAIN_TEXT_COLOR = Color(0xFF363639);
const Color SUB_TEXT_COLOR = Color(0xff8592a5);
const Color TUTO_TEXT_COLOR = Color(0xffb5d1ff);

class MainTheme {
  late BuildContext context;
  late ThemeData theme;
  MainTheme({required BuildContext argContext}) {
    context = argContext;

    theme = ThemeData(
      // ignore: deprecated_member_use

      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Noto Sans KR',
      primaryColor: const Color(0xFF1E4A75),
      highlightColor: const Color(0xFF1E4A75),
      hintColor: const Color(0xFF1E4A75),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Color(0xFF1E4A75),
        selectionColor: Color(0xFF1E4A75),
        selectionHandleColor: Color(0xFF1E4A75),
      ),
      dialogBackgroundColor: Colors.white,
      dialogTheme: DialogTheme(
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}
