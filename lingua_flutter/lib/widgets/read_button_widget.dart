import 'package:flutter/material.dart';

// ignore: camel_case_types
class ReadButtonWidget extends StatelessWidget {
  final void Function() onTapFunc;
  final String inButtonText;
  const ReadButtonWidget({
    super.key,
    required this.onTapFunc,
    required this.inButtonText,
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
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Center(
              child: Text(
                inButtonText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
