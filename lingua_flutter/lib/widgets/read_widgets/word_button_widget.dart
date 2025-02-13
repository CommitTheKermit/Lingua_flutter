import 'package:flutter/material.dart';
import 'package:lingua/widgets/commons/common.dart';
import 'package:lingua/screens_mobile/home/view/dialog/dialog_word_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: camel_case_types
class WordButtonWidget extends StatelessWidget {
  final String inButtonText;
  const WordButtonWidget({
    super.key,
    required this.inButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: GestureDetector(
          onTap: () {
            // ApiUtil.wordRecord(
            //   word: inButtonText,
            // );
            showDialog(
              context: context,
              builder: (context) {
                return DialogWordWidget(
                  argText: inButtonText,
                );
              },
            );
          },
          child: Container(
            height: 5.h,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: const Color(0xFF1E4A75),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
            child: Center(
              child: comnText(
                 inButtonText,
                colorFont: const Color(0xFFF8F9FA),
                fontSize: 2.h,
              ),
            ),
          )),
    );
  }
}
