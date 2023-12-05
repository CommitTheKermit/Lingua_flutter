import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/widgets/commons/common_text.dart';

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
      width: AppLingua.width * 0.9,
      height: AppLingua.height * 0.06,
      child: Center(
          child: commonText(
        labelText: argText,
        fontSize: AppLingua.width * 0.045,
        fontWeight: FontWeight.w700,
        fontColor: Colors.white,
      )),
    ),
  );
}
