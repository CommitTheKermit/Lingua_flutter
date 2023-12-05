import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/widgets/commons/common_text.dart';

AppBar commonAppBar({
  required BuildContext context,
  required String argText,
}) {
  return AppBar(
    centerTitle: true,
    title: commonText(
      labelText: argText,
      fontColor: const Color(0xFF171A1D),
      fontSize: AppLingua.height * 0.0225,
      fontWeight: FontWeight.w700,
    ),
    shadowColor: Colors.white,
    backgroundColor: Colors.white,
    elevation: 0.0,
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Image.asset(
        'assets/images/icon_back.png',
        width: AppLingua.height * 0.0275,
      ),
    ),
  );
}
