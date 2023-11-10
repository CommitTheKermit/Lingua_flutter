import 'package:flutter/material.dart';
import 'package:lingua/screens_mobile/read_screen.dart';
import 'package:lingua/util/api/api_util.dart';

class ColorChangeButtonWidget extends StatefulWidget {
  final ApiUtil apiUtil;
  const ColorChangeButtonWidget({
    super.key,
    required this.apiUtil,
  });

  @override
  State<ColorChangeButtonWidget> createState() =>
      _ColorChangeButtonWidgetState();
}

class _ColorChangeButtonWidgetState extends State<ColorChangeButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  bool isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
      ),
    )..addListener(() {
        setState(() {}); // 화면을 다시 그립니다.
      });

    _colorAnimation =
        ColorTween(begin: Colors.grey, end: Colors.white).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 30,
      onPressed: () {
        setState(() async {
          isPressed ? _controller.reverse() : _controller.forward();
          isPressed = !isPressed;

          ReadScreen.isAllowTranslate = !ReadScreen.isAllowTranslate;
          if (ReadScreen.isAllowTranslate && widget.apiUtil.API_KEY.isEmpty) {
            await widget.apiUtil.getApiKey();
          }
        }); // 화면을 다시 그립니다.
      },
      icon: Icon(
        Icons.translate_outlined,
        color: _colorAnimation.value,
      ),
      color: Colors.white,
    );
  }
}
