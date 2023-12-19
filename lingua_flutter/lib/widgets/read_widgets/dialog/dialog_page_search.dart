import 'package:flutter/material.dart';
import 'package:lingua/main.dart';

enum PageState {
  prev,
  current,
  next,
}

class DialogPageSearch extends StatefulWidget {
  const DialogPageSearch({
    super.key,
    required this.index,
    required this.pages,
  });

  final int index;
  final List<String> pages;

  @override
  State<DialogPageSearch> createState() => _DialogPageSearchState();
}

class _DialogPageSearchState extends State<DialogPageSearch> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  double _sliderValue = 0; // 초기값
  int index = 0;

  @override
  void initState() {
    super.initState();
    index = widget.index;
    _sliderValue = index.toDouble();
  }

  @override
  void dispose() {
    // 컨트롤러의 리소스를 제거합니다.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                AppLingua.titleNovel,
                style: TextStyle(
                  color: const Color(0xFF43698F),
                  fontSize: AppLingua.height * 0.03,
                  fontFamily: 'Noto Sans KR',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop('back');
                },
                icon: Image.asset("assets/images/icon_close.png",
                    height: AppLingua.height * 0.05),
              ),
            ),
          ],
        ),
      ),
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 20,
        bottom: 10,
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: AppLingua.width,
          height: AppLingua.height * 0.7,
          child: Column(
            children: [
              Container(
                height: AppLingua.height * 0.015,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 2, color: Color(0xFFDEE2E6)))),
              ),
              Container(
                height: AppLingua.height * 0.5,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppLingua.width * 0.04,
                  ),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Text(
                      widget.pages[index],
                      style: TextStyle(
                        fontSize: AppLingua.height * 0.03,
                        height: 1.7,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                child: SliderTheme(
                  data: SliderThemeData(
                    thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: AppLingua.height * 0.01),
                    trackHeight: AppLingua.height * 0.01,
                  ),
                  child: Slider(
                    activeColor: const Color(0xFF44698F),
                    thumbColor: const Color(0xFF1F4A76),
                    inactiveColor: const Color(0xFFDEE2E6),
                    value: _sliderValue,
                    onChanged: (value) {
                      setState(() {
                        _sliderValue = value;
                        index = _sliderValue.toInt();
                        _scrollController.jumpTo(0);
                      });
                    },
                    min: 0,
                    max: AppLingua.originalSentences.length.toDouble(),
                  ),
                ),
              ),
              Container(
                width: AppLingua.width * 0.3,
                height: AppLingua.height * 0.045,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side:
                        const BorderSide(width: 0.5, color: Color(0xFF868E96)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Center(
                  child: TextField(
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      setState(() {
                        _sliderValue = int.parse(value).toDouble();
                        index = _sliderValue.toInt();
                        _scrollController.jumpTo(0);
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: AppLingua.height * 0.009),
                      border: InputBorder.none,
                      hintText:
                          '${_sliderValue.toInt()}/${widget.pages.length}',
                      hintStyle: const TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, _sliderValue.toString());
                },
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          top: BorderSide(width: 1, color: Color(0xFFDEE2E6))),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5))),
                  height: AppLingua.height * 0.0675,
                  child: Center(
                      child: Text(
                    '이동',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF43698F),
                      fontSize: AppLingua.height * 0.025,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w700,
                    ),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
