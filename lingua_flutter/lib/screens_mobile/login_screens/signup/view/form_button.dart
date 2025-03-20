import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FormButton extends StatelessWidget {
  const FormButton({
    Key? key,
    required this.backgroundColor,
    required this.onPressed,
    required this.argText,
  }) : super(key: key);

  final Color backgroundColor;
  final void Function() onPressed;
  final String argText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        width: 90.w,
        height: 6.25.h,
        child: Center(
          child: Text(
            argText,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Neo',
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
