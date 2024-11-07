import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SingleTabButton extends StatelessWidget {
  const SingleTabButton({
    Key? key,
    required this.argText,
  }) : super(key: key);
  final String argText;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Text(
          argText,
          style: TextStyle(fontSize: 2.125.h),
        ),
      ),
    );
  }
}
