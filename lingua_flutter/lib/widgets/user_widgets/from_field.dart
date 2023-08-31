import 'package:flutter/material.dart';

Widget buildFormField({
  required FormFieldSetter<String> onSaved,
  required String labelText,
  required FormFieldValidator<String> validator,
  required bool isObscure,
  double? horizontalPadding,
  double? verticalPadding,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: horizontalPadding ?? 26.0,
      vertical: verticalPadding ?? 10,
    ),
    child: TextFormField(
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      onSaved: onSaved,
      validator: validator,
    ),
  );
}
