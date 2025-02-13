import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginFormField extends StatefulWidget {
  const LoginFormField({
    Key? key,
    required this.onSaved,
    required this.labelText,
    required this.validator,
    required this.isObscure,
    this.prefixImage,
    this.horizontalPadding,
    this.verticalPadding,
    this.controller,
    required this.textInputAction,
    required this.onSubmitted,
  }) : super(key: key);

  final FormFieldSetter<String> onSaved;
  final String labelText;
  final FormFieldValidator<String> validator;
  final bool isObscure;
  final Image? prefixImage;
  final double? horizontalPadding;
  final double? verticalPadding;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final Function(String) onSubmitted;

  @override
  State<LoginFormField> createState() => _LoginFormFieldState();
}

class _LoginFormFieldState extends State<LoginFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      height: 7.h,
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
          onFieldSubmitted: widget.onSubmitted,
          textInputAction: widget.textInputAction,
          controller: widget.controller,
          obscureText: widget.isObscure,
          onSaved: widget.onSaved,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.labelText,
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: const Color(0xFFADB5BD),
              fontSize: 2.h,
            ),
          ),
        ),
      ),
    );
  }
}
