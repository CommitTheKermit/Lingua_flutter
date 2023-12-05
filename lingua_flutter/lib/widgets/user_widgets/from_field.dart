import 'package:flutter/material.dart';
import 'package:lingua/main.dart';

Widget buildFormField({
  required FormFieldSetter<String> onSaved,
  required String labelText,
  required FormFieldValidator<String> validator,
  required bool isObscure,
  Image? prefixImage,
  double? horizontalPadding,
  double? verticalPadding,
  TextEditingController? controller,
}) {
  return Container(
    width: AppLingua.width * 0.9,
    height: AppLingua.height * 0.07,
    decoration: ShapeDecoration(
      color: const Color(0xFFF8F9FA),
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Color(0xFFDEE2E6)),
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        onSaved: onSaved,
        validator: validator,
        decoration: InputDecoration(
          hintText: labelText,
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: const Color(0xFFADB5BD),
            fontSize: AppLingua.height * 0.02,
          ),
        ),
      ),
    ),
  );
}
