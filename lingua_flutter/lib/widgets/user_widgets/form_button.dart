import 'package:flutter/material.dart';
import 'package:lingua/widgets/commons/common_text.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Widget buildFormButton({
  required Color backgroundColor,
  required void Function() onPressed,
  required String argText,
}) {
  return InkWell(
    splashColor: Colors.white,
    onTap: onPressed,
    child: Container(
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      width: 90.w,
      height: 6.h,
      child: Center(
          child: commonText(
        labelText: argText,
        fontSize: 4.5.w,
        fontWeight: FontWeight.w700,
        fontColor: Colors.white,
      )),
    ),
  );
}
