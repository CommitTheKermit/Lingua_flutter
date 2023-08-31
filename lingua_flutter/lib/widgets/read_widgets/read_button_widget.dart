import 'package:flutter/material.dart';

// ignore: camel_case_types
class ReadButtonWidget extends StatelessWidget {
  final void Function() onTapFunc;
  final String inButtonText;
  final bool indexLimit;
  const ReadButtonWidget({
    super.key,
    required this.onTapFunc,
    required this.inButtonText,
    required this.indexLimit,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 10,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: GestureDetector(
          onTap: onTapFunc,
          child: Container(
            decoration: BoxDecoration(
              color: indexLimit
                  ? Colors.grey.shade400
                  : Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Center(
              child: Text(
                inButtonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
