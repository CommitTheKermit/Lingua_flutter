import 'package:flutter/material.dart';
import 'package:lingua/main.dart';

Future comnShowDialog({
  required Widget dialog,
}) async {
  return await showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) => dialog,
  );
}
