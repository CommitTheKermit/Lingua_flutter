import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/models/bookmark_model.dart';

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
        width: AppLingua.width * 0.9,
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
              height: AppLingua.height * 0.03,
            ),
            SizedBox(
              width: AppLingua.width * 0.03,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: AppLingua.width * 0.7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.bookmark.bookMarkedLine}번째 줄',
                        style: TextStyle(
                          color: const Color(0xFF495057),
                          fontSize: AppLingua.height * 0.02,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: widget.onTapMove,
                            child: Container(
                              width: AppLingua.width * 0.1125,
                              height: AppLingua.height * 0.03,
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
                                    fontSize: AppLingua.height * 0.015,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: AppLingua.height * 0.01,
                          ),
                          GestureDetector(
                            onTap: widget.onTapDelete,
                            child: Container(
                              width: AppLingua.width * 0.1125,
                              height: AppLingua.height * 0.03,
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
                                    fontSize: AppLingua.height * 0.015,
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
                        fontSize: AppLingua.height * 0.0175,
                        fontFamily: 'Noto Sans KR',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppLingua.height * 0.01,
                ),
                SizedBox(
                  width: AppLingua.width * 0.7,
                  height: AppLingua.height * 0.06,
                  child: Text(
                    widget.bookmark.bookMarkedPage,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF171A1D),
                      fontSize: AppLingua.height * 0.0175,
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
