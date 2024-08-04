import 'package:flutter/material.dart';
import 'package:lingua/models/bookmark_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BookmarkResultWidget extends StatefulWidget {
  const BookmarkResultWidget({
    super.key,
    required this.onTapMove,
    required this.onTapDelete,
    required this.bookmark,
    required this.bookmarks,
  });

  final List<BookmarkModel> bookmarks;
  final void Function()? onTapMove;
  final void Function()? onTapDelete;
  final BookmarkModel bookmark;

  @override
  State<BookmarkResultWidget> createState() => _BookmarkResultWidgetState();
}

class _BookmarkResultWidgetState extends State<BookmarkResultWidget> {
  @override
  Widget build(BuildContext context) {
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
            Image.asset(
              'assets/images/icon_bookmark.png',
              height: 3.h,
            ),
            SizedBox(
              width: 3.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 70.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.bookmark.bookMarkedLine}번째 줄',
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
                          SizedBox(
                            width: 1.h,
                          ),
                          GestureDetector(
                            onTap: widget.onTapDelete,
                            child: Container(
                              width: 11.25.w,
                              height: 3.h,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFF8F9FA),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1, color: Color(0xFFD7260D)),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '삭제',
                                  style: TextStyle(
                                    color: const Color(0xFFD7260D),
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
                Row(
                  children: [
                    Text(
                      '${widget.bookmark.bookMarkedTime.year}-${widget.bookmark.bookMarkedTime.month}-${widget.bookmark.bookMarkedTime.day} ${widget.bookmark.bookMarkedTime.hour}:${widget.bookmark.bookMarkedTime.minute}:${widget.bookmark.bookMarkedTime.second} 저장',
                      style: TextStyle(
                        color: const Color(0xFF495057),
                        fontSize: 1.75.h,
                        fontFamily: 'Noto Sans KR',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                SizedBox(
                  width: 70.w,
                  height: 6.h,
                  child: Text(
                    widget.bookmark.bookMarkedPage,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF171A1D),
                      fontSize: 1.75.h,
                      height: 1.5,
                    ),
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
