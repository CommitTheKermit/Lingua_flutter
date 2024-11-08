import 'package:flutter/material.dart';
import 'package:lingua/screens_mobile/home/view_model/home_prov.dart';
import 'package:lingua/utils/shared_preferences/preferences.dart';
import 'package:provider/provider.dart';

class TranslateAllowButton extends StatefulWidget {
  final String assetName;
  final VoidCallback onPressedCallback; // 부모로부터 전달받을 콜백
  final double iconSize;
  const TranslateAllowButton({
    super.key,
    required this.assetName,
    required this.onPressedCallback,
    required this.iconSize,
  });

  @override
  State<TranslateAllowButton> createState() => _TranslateAllowButtonState();
}

class _TranslateAllowButtonState extends State<TranslateAllowButton>
    with SingleTickerProviderStateMixin {
  bool isPressed = false;

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
      onPressed: () async {
        readProv.model.isAllowTranslate = !readProv.model.isAllowTranslate;
        setPrefBool('isAllowTranslate', readProv.model.isAllowTranslate);
        if (readProv.model.isAllowTranslate) {}
        widget.onPressedCallback();
      },
      icon: Image.asset(
        widget.assetName,
        height: widget.iconSize,
        color: readProv.model.isAllowTranslate
            ? const Color(0xFF44698F)
            : const Color(0xFF868e96),
      ),
      color: Colors.white,
    );
  }
}
