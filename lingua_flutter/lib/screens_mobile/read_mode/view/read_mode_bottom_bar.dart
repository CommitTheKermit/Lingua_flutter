import 'package:flutter/material.dart';
import 'package:lingua/screens_mobile/read_mode/view_model/read_mode_prov.dart';
import 'package:lingua/screens_mobile_old/bookmark_list_dialog.dart';
import 'package:lingua/widgets/commons/common.dart';
import 'package:lingua/widgets/read_widgets/dialog/dialog_page_search.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReadModeBottomBar extends StatefulWidget {
  const ReadModeBottomBar({Key? key}) : super(key: key);

  @override
  State<ReadModeBottomBar> createState() => _ReadModeBottomBarState();
}

class _ReadModeBottomBarState extends State<ReadModeBottomBar> {
  @override
  Widget build(BuildContext context) {
    ReadModeProv readProv = Provider.of<ReadModeProv>(context);
    return SlideTransition(
      position: readProv.model.bottomMenuOffset,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Opacity(
          opacity: 0.9,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
              border: Border(
                top: BorderSide(width: 1, color: Color(0xFFDEE2E6)),
              ),
            ),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 5.w,
                  right: 5.w,
                  top: 1.8.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/icon_bookmarks.png",
                          height: 3.h,
                        ),
                        SizedBox(
                          width: 2.2.w,
                        ),
                        comnText(
                          '현재 문서내 책갈피 ${readProv.model.bookmarkedLines.length}개',
                          fontSize: 2.h,
                          weightFont: FontWeight.w500,
                          colorFont: const Color(0xFF1E4A75),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        String? result = await showDialog(
                          context: context,
                          builder: (context) {
                            return BookmarkListDialog(
                              bookmarks: readProv.model.bookmarks,
                            );
                          },
                        );
                        if (result != null) {
                          if (result.startsWith('move')) {
                            setState(() {
                              String tempResult = result.substring(result.indexOf(':') + 1);

                              readProv.model.index = double.parse(tempResult);
                            });
                          }
                        }
                      },
                      child: Row(
                        children: [
                          comnText(
                            '책갈피 목록',
                            fontSize: 1.5.h,
                            weightFont: FontWeight.w400,
                            colorFont: const Color(0xFF1E4A75),
                          ),
                          Image.asset(
                            'assets/images/icon_small_arrow.png',
                            height: 1.5.h,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 5.w,
                  right: 5.w,
                  top: 1.8.h,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/icon_text.png',
                      height: 3.h,
                    ),
                    SizedBox(
                      width: 50.w,
                      height: 1.875.h,
                      child: SliderTheme(
                        data: SliderThemeData(
                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 1.h)),
                        child: Slider(
                          activeColor: const Color(0xFF44698F),
                          thumbColor: const Color(0xFF1F4A76),
                          value: readProv.model.index,
                          onChanged: (value) {
                            setState(() {
                              readProv.model.index = value;
                            });
                          },
                          min: 0,
                          max: (readProv.model.pages.length - 1).toDouble(),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        String result = await showDialog(
                          context: context,
                          builder: (context) {
                            return DialogPageSearch(
                              index: readProv.model.index.toInt(),
                              pages: readProv.model.pages,
                            );
                          },
                        );
                        setState(() {
                          if (result == 'back') {
                            return;
                          }
                          // index = result;
                          // IndexSaveLoad.saveCurrentIndex(index);
                          // originalSingleSentence = originalSentences[index];
                          // words = extractWords(originalSingleSentence);
                          // _scrollController.jumpTo(0);

                          readProv.model.index = double.parse(result);
                        });
                      },
                      child: Container(
                        width: 30.w,
                        height: 4.5.h,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 0.5, color: Color(0xFF868E96)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              comnText(
                                readProv.model.index.toStringAsFixed(0),
                                colorFont: const Color(0xFF1E4A75),
                                fontSize: 2.25.h,
                                weightFont: FontWeight.w700,
                              ),
                              comnText(
                                "/${readProv.model.pages.length - 1}",
                                colorFont: const Color(0xFF868E96),
                                fontSize: 2.25.h,
                                weightFont: FontWeight.w700,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
