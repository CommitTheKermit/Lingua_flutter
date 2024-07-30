import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lingua/models/search_result_model.dart';
import 'package:lingua/widgets/read_widgets/search_result_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchListDialog extends StatefulWidget {
  final List<String> pages;
  const SearchListDialog({
    super.key,
    required this.pages,
  });

  @override
  State<SearchListDialog> createState() => _SearchListDialogState();
}

class _SearchListDialogState extends State<SearchListDialog> {
  final TextEditingController _controller = TextEditingController();
  final List<SearchResultModel> _searchResults = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // 컨트롤러의 리소스를 제거합니다.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      actions: [
        Center(
          child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: Text(
                  '닫기',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF43698F),
                    fontSize:2.25.h,
                    fontWeight: FontWeight.w700,
                  ),
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
            ),
            border: InputBorder.none,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _searchResults.clear();
                  for (var page in widget.pages) {
                    if (page
                        .toLowerCase()
                        .contains(_controller.text.toLowerCase())) {
                      _searchResults.add(
                        SearchResultModel(
                            pageNumber: widget.pages.indexOf(page),
                            pageContent: page),
                      );
                    }
                  }
                });
                log(_searchResults.length.toString());
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
            child: Column(
          children: [
            for (var result in _searchResults)
              SearchResultWidget(
                targetWord: _controller.text,
                searchResult: result,
                onTapMove: () {
                  Navigator.pop(context,
                      'move :${widget.pages[widget.pages.indexOf(result.pageContent)]}');
                },
              ),
          ],
        )),
      ),
    );
  }
}
