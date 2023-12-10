import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/models/bookmark_model.dart';
import 'package:lingua/screens_mobile/bookmark_result_widget.dart';
import 'package:lingua/util/api/api_util.dart';
import 'package:lingua/widgets/read_widgets/dictionary_result_widget.dart';

class BookmarkListDialog extends StatefulWidget {
  final List<BookmarkModel> bookmarks;
  const BookmarkListDialog({
    super.key,
    required this.bookmarks,
  });

  @override
  State<BookmarkListDialog> createState() => _BookmarkListDialogState();
}

class _BookmarkListDialogState extends State<BookmarkListDialog> {
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
                  fontSize: AppLingua.height * 0.0225,
                  fontWeight: FontWeight.w700,
                ),
              )),
        )
      ],
      contentPadding: EdgeInsets.zero,
      insetPadding:
          const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
      title: Padding(
        padding: EdgeInsets.only(bottom: AppLingua.height * 0.015),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/icon_bookmarks.png',
              height: AppLingua.height * 0.03,
            ),
            SizedBox(
              width: AppLingua.width * 0.02,
            ),
            Text(
              '책갈피 목록',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF43698F),
                fontSize: AppLingua.height * 0.025,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
      ),
      content: Container(
        decoration: const BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(width: 1, color: Color(0xFFDEE2E6)),
          ),
        ),
        width: AppLingua.width,
        height: AppLingua.height * 0.7,
        child: SingleChildScrollView(
            child: BookmarkListWidget(
          bookmarks: widget.bookmarks,
        )),
      ),
    );
  }
}
