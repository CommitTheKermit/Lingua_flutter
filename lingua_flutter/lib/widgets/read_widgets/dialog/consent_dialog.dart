import 'package:flutter/material.dart';
import 'package:lingua/main.dart';

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
            horizontal: AppLingua.width * 0.0375, vertical: 0),
        title: Text(
          title,
          style: TextStyle(
            color: const Color(0xFF171A1D),
            fontSize: AppLingua.height * 0.0225,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          content,
          style: TextStyle(
            color: const Color(0xFF171A1D),
            fontSize: AppLingua.height * 0.02,
          ),
        ),
        actionsPadding: EdgeInsets.zero,
        actions: [
          Center(
            child: TextButton(
              child: Container(
                width: AppLingua.width,
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
                        vertical: AppLingua.height * 0.0125),
                    child: Text(
                      '확인',
                      style: TextStyle(
                        color: const Color(0xFF43698F),
                        fontSize: AppLingua.height * 0.0225,
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
