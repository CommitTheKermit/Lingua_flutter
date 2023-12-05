import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/widgets/commons/common_text.dart';
import 'package:lingua/widgets/read_widgets/dialog/dialog_word_widget.dart';

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
            height: AppLingua.height * 0.05,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: const Color(0xFF1E4A75),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
            child: Center(
              child: commonText(
                labelText: inButtonText,
                fontColor: const Color(0xFFF8F9FA),
                fontSize: AppLingua.height * 0.02,
              ),
            ),
          )),
    );
  }
}
