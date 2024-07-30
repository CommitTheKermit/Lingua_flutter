import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<dynamic> consentDialog({
  required String title,
  required String content,
  required BuildContext context,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.symmetric(
            horizontal: 3.75.w, vertical: 0),
        title: Text(
          title,
          style: TextStyle(
            color: const Color(0xFF171A1D),
            fontSize: 2.25.h,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          content,
          style: TextStyle(
            color: const Color(0xFF171A1D),
            fontSize: 2.h,
          ),
        ),
        actionsPadding: EdgeInsets.zero,
        actions: [
          Center(
            child: TextButton(
              child: Container(
                width: 100.w,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 2,
                      color: Color(0xFFDEE2E6),
                    ),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 1.25.h),
                    child: Text(
                      '확인',
                      style: TextStyle(
                        color: const Color(0xFF43698F),
                        fontSize: 2.25.h,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // 알림 창을 닫습니다.
              },
            ),
          ),
        ],
      );
    },
  );
}
