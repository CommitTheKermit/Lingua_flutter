import 'package:flutter/material.dart';

Future<dynamic> consentDialog({
  required String title,
  required String content,
  required BuildContext context,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text('확인'),
            onPressed: () {
              Navigator.of(context).pop(); // 알림 창을 닫습니다.
            },
          ),
        ],
      );
    },
  );
}
