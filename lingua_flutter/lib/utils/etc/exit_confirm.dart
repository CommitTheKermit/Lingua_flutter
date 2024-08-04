import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lingua/widgets/read_widgets/dialog/ask_dialog.dart';

Future<bool> exitConfirm(var context) async {
  final shouldExit = await showDialog(
    context: context,
    builder: (context) => AskDialog(
      title: '앱을 종료하시겠습니까?',
      content: '',
      leftBtnStr: '아니요',
      leftTap: () {
        Navigator.of(context).pop(false);
      },
      rightBtnStr: '예',
      rightTap: () {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      },
    ),
    // AlertDialog(
    //   title: const Text('앱을 종료하시겠습니까?'),
    //   actions: [
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         TextButton(
    //           child: const Text('아니요'),
    //           onPressed: () {
    //             Navigator.of(context).pop(false);
    //           },
    //         ),
    //         TextButton(
    //           child: const Text('예'),
    //           onPressed: () {
    //             if (Platform.isAndroid) {
    //               SystemNavigator.pop();
    //             } else if (Platform.isIOS) {
    //               exit(0);
    //             }
    //           },
    //         ),
    //       ],
    //     )
    //   ],
    // ),
  );

  return shouldExit ?? false;
}
