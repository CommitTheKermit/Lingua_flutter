import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/models/word_model.dart';
import 'package:lingua/utils/api/api_util.dart';
import 'package:lingua/widgets/read_widgets/dictionary_result_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DialogWordWidget extends StatefulWidget {
  final String argText;
  const DialogWordWidget({
    super.key,
    required this.argText,
  });

  @override
  State<DialogWordWidget> createState() => _DialogWordWidgetState();
}

class _DialogWordWidgetState extends State<DialogWordWidget> {
  final ScrollController _scrollController = ScrollController();
  late Future<List<WordModel>> wordMeans;

  @override
  void initState() {
    super.initState();
    // wordMeans = dictSearch(widget.argText);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     dialogButton(
            //       context,
            //       '이전',
            //       Theme.of(context).primaryColor,
            //     ),
            //     dialogButton(
            //       context,
            //       '다음',
            //       Theme.of(context).primaryColor,
            //     ),
            //   ],
            // ),
            dialogButton(
              context,
              '닫기',
              Theme.of(context).primaryColor,
            ),
          ],
        )
      ],
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      title: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Center(
          child: Text(
            widget.argText,
            style: TextStyle(
              color: const Color(0xFF43698F),
              fontSize: 3.5.h,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      content: Container(
        decoration: const BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              width: 1,
              color: Color(0xFFDEE2E6),
            ),
          ),
        ),
        width: 100.w,
        height: 100.h,
        child: DictionaryResultWidget(
            wordMeans: wordMeans, scrollController: _scrollController),
      ),
    );
  }

  TextButton dialogButton(BuildContext context, String argText, Color color) {
    return TextButton(
      child: Text(
        argText,
        style: TextStyle(
          color: const Color(0xFF43698F),
          fontSize: 2.25.h,
          fontWeight: FontWeight.w700,
          fontFamily: 'Noto Sans KR',
          height: 0,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
