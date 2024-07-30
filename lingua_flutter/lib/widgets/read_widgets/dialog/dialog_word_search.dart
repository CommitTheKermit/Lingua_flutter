import 'package:flutter/material.dart';
import 'package:lingua/models/word_model.dart';
import 'package:lingua/util/api/api_util.dart';
import 'package:lingua/widgets/read_widgets/dictionary_result_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

enum PageState {
  prev,
  current,
  next,
}

class DialogWordSearch extends StatefulWidget {
  const DialogWordSearch({
    super.key,
  });

  @override
  State<DialogWordSearch> createState() => _DialogWordSearchState();
}

class _DialogWordSearchState extends State<DialogWordSearch> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  Future<List<WordModel>>? wordMeans;

  @override
  void initState() {
    super.initState();
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
      actions: [
        Center(
          child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '닫기',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF43698F),
                  fontSize: 2.25.h,
                  fontWeight: FontWeight.w700,
                ),
              )),
        )
      ],
      contentPadding: EdgeInsets.zero,
      insetPadding:
          const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
      title: Container(
        margin: EdgeInsets.only(bottom: 1.25.h),
        decoration: ShapeDecoration(
          color: const Color(0xFFE9ECEF),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFF43698F)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Center(
            child: TextField(
          controller: _controller,
          style: TextStyle(fontSize: 2.5.h),
          autocorrect: true,
          decoration: InputDecoration(
            hintText: '영단어를 입력해 주세요.',
            hintStyle: TextStyle(
              color: const Color(0xFFADB5BD),
              fontSize: 2.5.h,
              fontFamily: 'Noto Sans KR',
            ),
            border: InputBorder.none,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  wordMeans = ApiUtil.dictSearch(_controller.text);
                });
              },
              child: Image.asset(
                "assets/images/icon_magnifier.png",
                scale: 1.3,
              ),
            ),
            contentPadding: const EdgeInsets.all(15.0),
          ),
        )),
      ),
      content: Container(
        decoration: const BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(width: 1, color: Color(0xFFDEE2E6)),
          ),
        ),
        width: 100.w,
        height: 70.h,
        child: SingleChildScrollView(
            controller: _scrollController,
            child: DictionaryResultWidget(
              wordMeans: wordMeans,
              scrollController: _scrollController,
            )),
      ),
    );
  }
}
