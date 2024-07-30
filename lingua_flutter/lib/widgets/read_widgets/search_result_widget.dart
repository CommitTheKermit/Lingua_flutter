import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/models/search_result_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchResultWidget extends StatefulWidget {
  const SearchResultWidget({
    super.key,
    required this.onTapMove,
    required this.searchResult,
    required this.targetWord,
  });
  final void Function()? onTapMove;
  final SearchResultModel searchResult;
  final String targetWord;

  @override
  State<SearchResultWidget> createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends State<SearchResultWidget> {
  @override
  Widget build(BuildContext context) {
    int targetIndex = widget.searchResult.pageContent
        .toLowerCase()
        .indexOf(widget.targetWord);
    int variance = 60;

    int prefixLimit = targetIndex - variance > 0 ? targetIndex - variance : 0;
    if (prefixLimit != 0 &&
        widget.searchResult.pageContent[prefixLimit] != ' ') {
      prefixLimit = prefixLimit +
          widget.searchResult.pageContent.substring(prefixLimit).indexOf(' ');
    }

    int suffixLimit =
        targetIndex + variance > widget.searchResult.pageContent.length
            ? widget.searchResult.pageContent.length
            : targetIndex + variance;

    if (suffixLimit != widget.searchResult.pageContent.length &&
        widget.searchResult.pageContent[suffixLimit] != ' ') {
      suffixLimit = suffixLimit +
          widget.searchResult.pageContent.substring(suffixLimit).indexOf(' ');
    }
    String prefix =
        widget.searchResult.pageContent.substring(prefixLimit, targetIndex);
    String suffix = widget.searchResult.pageContent
        .substring(targetIndex + widget.targetWord.length, suffixLimit);

    prefix = prefix.replaceAll('\n', '');
    suffix = suffix.replaceAll('\n', '');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: 90.w,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFDEE2E6)),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 77.5.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 1.w,
                      ),
                      Text(
                        '${widget.searchResult.pageNumber} 쪽',
                        style: TextStyle(
                          color: const Color(0xFF495057),
                          fontSize: 2.h,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: widget.onTapMove,
                            child: Container(
                              width: 11.25.w,
                              height: 3.h,
                              decoration: ShapeDecoration(
                                color: const Color(0xFF43698F),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              child: Center(
                                child: Text(
                                  '이동',
                                  style: TextStyle(
                                    color: const Color(0xFFF8F9FA),
                                    fontSize: 1.5.h,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                SizedBox(
                  width: 70.w,
                  height: 9.h,
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: prefix,
                        style: TextStyle(
                          color: const Color(0xFF363639),
                          fontSize: 2.h,
                        ),
                      ),
                      TextSpan(
                        text: widget.targetWord,
                        style: TextStyle(
                          color: const Color(0xFF363639),
                          fontSize: 2.h,
                        ),
                      ),
                      TextSpan(
                        text: suffix,
                        style: TextStyle(
                          color: const Color(0xFF363639),
                          fontSize: 2.h,
                        ),
                      ),
                    ]),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    // style: TextStyle(
                    //   color: const Color(0xFF171A1D),
                    //   fontSize: height * 0.0175,
                    //   height: 1.5,
                    // ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
