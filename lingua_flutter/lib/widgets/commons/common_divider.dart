import 'package:flutter/material.dart';

Container commonDivider (BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 8,
    decoration: const ShapeDecoration(
      color: Color(0xFFF4F4F4),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 0.25,
          strokeAlign: BorderSide.strokeAlignOutside,
          color: Color(0xFFC6C6C6),
        ),
      ),
    ),
  );
}
