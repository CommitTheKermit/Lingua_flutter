import 'package:flutter/material.dart';

class InteractableTextsWidget extends StatelessWidget {
  const InteractableTextsWidget({
    super.key,
    required this.readTextStyle,
    required this.splitted,
  });

  final TextStyle readTextStyle;
  final List splitted;

  @override
  Widget build(BuildContext context) {
    return RichText(
      strutStyle: StrutStyle(
        fontSize: readTextStyle.fontSize,
        height: readTextStyle.height,
        fontFamily: readTextStyle.fontFamily,
      ),
      text: TextSpan(
        style: readTextStyle,
        children: [
          for (String singleWord in splitted)
            TextSpan(
              text: '$singleWord ',
            ),
        ], //터치하면 그 부분이 굵어지게 만들것
      ),
    );
  }
}
