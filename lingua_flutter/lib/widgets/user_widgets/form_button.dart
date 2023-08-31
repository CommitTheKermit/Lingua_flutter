import 'package:flutter/material.dart';

Widget buildFormButton({
  required Color backgroundColor,
  required void Function() onPressed,
  required String argText,
  required BuildContext context,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 2),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
      ),
      onPressed: onPressed,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Center(
          child: Text(
            argText,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Neo',
            ),
          ),
        ),
      ),
    ),
  );
}
