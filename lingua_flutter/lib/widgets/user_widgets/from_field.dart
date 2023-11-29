import 'package:flutter/material.dart';

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
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: horizontalPadding ?? 26.0,
      vertical: verticalPadding ?? 10,
    ),
    child: TextFormField(
      controller: controller,
      obscureText: isObscure,
      onSaved: onSaved,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        prefixIcon: prefixImage != null
            ? Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    prefixImage,
                    const SizedBox(
                      width: 16,
                    ),
                    Image.asset('assets/images/divider.png'),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                ),
              )
            : null,
      ),
    ),
  );
}
