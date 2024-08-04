import 'package:flutter/material.dart';
import 'package:lingua/widgets/commons/common_text.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

AppBar commonAppBar({
  required BuildContext context,
  required String argText,
}) {
  return AppBar(
    centerTitle: true,
    title: comnText(
      labelText: argText,
      fontColor: const Color(0xFF171A1D),
      fontSize: 2.25.h,
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
        width: 2.75.w,
      ),
    ),
  );
}
