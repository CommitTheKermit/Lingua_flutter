import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OptionSingleContainer extends StatelessWidget {
  const OptionSingleContainer({
    Key? key,
    required this.containerHeight,
    required this.lines,
    this.mainAxisAlignment = MainAxisAlignment.center,
  }) : super(key: key);

  final double containerHeight;
  final List<Widget> lines;
  final MainAxisAlignment mainAxisAlignment;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: containerHeight,
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (lines != null) ...lines,
        ],
      ),
    );
  }
}
