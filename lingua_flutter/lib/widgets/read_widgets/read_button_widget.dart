import 'package:flutter/material.dart';

// ignore: camel_case_types
class ReadButtonWidget extends StatelessWidget {
  final void Function() onTapFunc;
  final String imageFileOn;
  final String imageFileOff;
  final bool indexLimit;
  const ReadButtonWidget({
    super.key,
    required this.onTapFunc,
    required this.indexLimit,
    required this.imageFileOn,
    required this.imageFileOff,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 10,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: GestureDetector(
          onTap: onTapFunc,
          child: Image.asset(
            indexLimit ? imageFileOff : imageFileOn,
          ),
        ),
      ),
    );
  }
}
