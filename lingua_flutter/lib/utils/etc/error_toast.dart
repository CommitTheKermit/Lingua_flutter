import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> errorToast({
  required String argText,
}) {
  return Fluttertoast.showToast(
      msg: argText,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color(0xFF8FC1E4),
      textColor: Colors.white,
      fontSize: 16.0);
}
