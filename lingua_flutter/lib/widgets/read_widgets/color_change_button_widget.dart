import 'package:flutter/material.dart';

class ColorChangeButtonWidget extends StatefulWidget {
  const ColorChangeButtonWidget({super.key});

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
        setState(() {
          isPressed ? _controller.reverse() : _controller.forward();
          isPressed = !isPressed;
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
