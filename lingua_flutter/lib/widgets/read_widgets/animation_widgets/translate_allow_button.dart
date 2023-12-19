import 'package:flutter/material.dart';
import 'package:lingua/screens_mobile/main_screens/read_screen.dart';
import 'package:lingua/util/api/api_util.dart';
import 'package:lingua/util/shared_preferences/preference_manager.dart';
import 'package:lingua/widgets/read_widgets/dialog/consent_dialog.dart';

class TranslateAllowButton extends StatefulWidget {
  final ApiUtil apiUtil;
  final String assetName;
  final VoidCallback onPressedCallback; // 부모로부터 전달받을 콜백
  final double iconSize;
  const TranslateAllowButton({
    super.key,
    required this.apiUtil,
    required this.assetName,
    required this.onPressedCallback,
    required this.iconSize,
  });

  @override
  State<TranslateAllowButton> createState() => _TranslateAllowButtonState();
}

class _TranslateAllowButtonState extends State<TranslateAllowButton>
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

    // _colorAnimation =
    //     ColorTween(begin: const Color(0xFF868e96), end: const Color(0xFF44698F))
    //         .animate(_controller);
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 20,
      onPressed: () async {
        // ReadScreen.isAllowTranslate
        //     ? _controller.reverse()
        //     : _controller.forward();

        ReadScreen.isAllowTranslate = !ReadScreen.isAllowTranslate;
        PreferenceManager.saveBoolValue(
            'isAllowTranslate', ReadScreen.isAllowTranslate);
        if (ReadScreen.isAllowTranslate && ApiUtil.API_KEY.isEmpty) {
          try {
            await widget.apiUtil.getApiKey();
          } catch (e) {
            ReadScreen.isAllowTranslate = false;
            consentDialog(
                title: '인터넷 연결 필요',
                content: '번역 기능은 인터넷 연결이 필요합니다.',
                context: context);
          }
        }
        widget.onPressedCallback();
      },
      icon: Image.asset(
        widget.assetName,
        height: widget.iconSize,
        color: ReadScreen.isAllowTranslate
            ? const Color(0xFF44698F)
            : const Color(0xFF868e96),
      ),
      color: Colors.white,
    );
  }
}
