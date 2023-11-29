import 'package:flutter/material.dart';
import 'package:lingua/screens_mobile/read_screen.dart';
import 'package:lingua/util/api/api_util.dart';

class InputAllowButton extends StatefulWidget {
  final ApiUtil apiUtil;
  final String assetName;
  final VoidCallback onPressedCallback; // 부모로부터 전달받을 콜백
  final double iconSize;
  const InputAllowButton({
    super.key,
    required this.apiUtil,
    required this.assetName,
    required this.onPressedCallback,
    required this.iconSize,
  });

  @override
  State<InputAllowButton> createState() => _InputAllowButtonState();
}

class _InputAllowButtonState extends State<InputAllowButton>
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

    _colorAnimation = ColorTween(
      begin: const Color(0xFF44698F),
      end: const Color(0xFF868e96),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 20,
      onPressed: () {
        setState(() {
          ReadScreen.isAllowInput = !ReadScreen.isAllowInput;
          ReadScreen.isAllowInput
              ? _controller.reverse()
              : _controller.forward();
        }); // 화면을 다시 그립니다.
        widget.onPressedCallback();
      },
      icon: Image.asset(
        widget.assetName,
        height: widget.iconSize,
        color: _colorAnimation.value,
      ),
      color: Colors.white,
    );
  }
}
