import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: must_be_immutable
class AskDialog extends StatelessWidget {
  AskDialog({
    super.key,
    required this.title,
    required this.content,
    required this.leftBtnStr,
    this.leftTap,
    required this.rightBtnStr,
    required this.rightTap,
  });

  final String title;
  final String content;
  final String leftBtnStr;
  final String rightBtnStr;
  void Function()? leftTap;
  final void Function() rightTap;
  @override
  Widget build(BuildContext context) {
    leftTap ??= () {
      Navigator.of(context).pop('exit');
    };
    return AlertDialog(
      actionsPadding: EdgeInsets.zero,
      titlePadding: content.isEmpty
          ? const EdgeInsets.only(left: 24, right: 24, bottom: 0, top: 24)
          : null,
      contentPadding: content.isEmpty ? EdgeInsets.zero : null,
      title: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF171A1D),
          fontSize: 2.25.h,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: SizedBox(
        width: 80.w,
        height:
            content.isEmpty ? 4.h : 8.h,
        child: Text(
          content,
          style: TextStyle(
            color: const Color(0xFF171A1D),
            fontSize: 2.h,
          ),
        ),
      ),
      actions: [
        Container(
          height: 6.75.h,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: 1.5, color: Color(0xFFDEE2E6)),
            ),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: InkWell(
                  onTap: leftTap,
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(width: 1.5, color: Color(0xFFDEE2E6)),
                      ),
                    ),
                    child: Center(
                        child: Text(
                      leftBtnStr,
                      style: TextStyle(
                        color: const Color(0xFF43698F),
                        fontSize: 2.25.h,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: InkWell(
                  onTap: rightTap,
                  child: SizedBox(
                    height: 6.75.h,
                    child: Center(
                        child: Text(
                      rightBtnStr,
                      style: TextStyle(
                        color: const Color(0xFF43698F),
                        fontSize: 2.25.h,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
