import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
                titleNovel,
                style: TextStyle(
                  color: const Color(0xFF43698F),
                  fontSize: 3.h,
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
                    height: 5.h),
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
          width: 100.w,
          height: 70.h,
          child: Column(
            children: [
              Container(
                height: 1.5.h,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 2, color: Color(0xFFDEE2E6)))),
              ),
              Container(
                height: 50.h,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                  ),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Text(
                      widget.pages[index],
                      style: TextStyle(
                        fontSize: 3.h,
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
                        enabledThumbRadius: 1.h),
                    trackHeight: 1.h,
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
                    max: originalSentences.length.toDouble(),
                  ),
                ),
              ),
              Container(
                width: 30.w,
                height: 4.5.h,
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
                          vertical: 0.9.h),
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
                  height: 6.75.h,
                  child: Center(
                      child: Text(
                    '이동',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF43698F),
                      fontSize: 2.5.h,
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
