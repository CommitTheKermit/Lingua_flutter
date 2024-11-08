import 'package:flutter/material.dart';
import 'package:lingua/screens_mobile/home/view_model/home_prov.dart';
import 'package:lingua/utils/shared_preferences/preferences.dart';
import 'package:provider/provider.dart';

class InputAllowButton extends StatefulWidget {
  final String assetName;
  final VoidCallback onPressedCallback; // 부모로부터 전달받을 콜백
  final double iconSize;
  const InputAllowButton({
    super.key,
    required this.assetName,
    required this.onPressedCallback,
    required this.iconSize,
  });

  @override
  State<InputAllowButton> createState() => _InputAllowButtonState();
}

class _InputAllowButtonState extends State<InputAllowButton>
    with SingleTickerProviderStateMixin {
  // late AnimationController _controller;
  // late Animation<Color?> _colorAnimation;
  bool isPressed = false;

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(
    //   vsync: this,
    //   duration: const Duration(
    //     milliseconds: 200,
    //   ),
    // )..addListener(() {
    //     setState(() {}); // 화면을 다시 그립니다.
    //   });

    // _colorAnimation = ColorTween(
    //   begin: const Color(0xFF44698F),
    //   end: const Color(0xFF868e96),
    // ).animate(_controller);
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomeProv readProv = Provider.of<HomeProv>(context);
    return IconButton(
      iconSize: 20,
      onPressed: () {
        setState(() {
          // ReadScreen.isAllowInput ? _controller.reverse() : _controller.forward();
          readProv.model.isAllowInput = !readProv.model.isAllowInput;
          setPrefBool(
              'isAllowInput', readProv.model.isAllowInput);
        });
        widget.onPressedCallback();
      },
      icon: Image.asset(
        widget.assetName,
        height: widget.iconSize,
        color: readProv.model.isAllowInput
            ? const Color(0xFF44698F)
            : const Color(0xFF868e96),
      ),
      color: Colors.white,
    );
  }
}
