import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<bool> exitConfirm(var context) async {
  // 이곳에 종료 전에 수행하고 싶은 작업을 추가합니다.
  final shouldExit = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('앱을 종료하시겠습니까?'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              child: const Text('아니요'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('예'),
              onPressed: () {
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else if (Platform.isIOS) {
                  exit(0);
                }
              },
            ),
          ],
        )
      ],
    ),
  );

  return shouldExit ?? false;
}
