import 'package:flutter/material.dart';
import 'package:lingua/widgets/commons/common.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CompleteFormButton extends StatelessWidget {
  const CompleteFormButton({
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
            child: comnText(
          argText,
          fontSize: 4.5.w,
          weightFont: FontWeight.w700,
          colorFont: Colors.white,
        )),
      ),
    );
  }
}
