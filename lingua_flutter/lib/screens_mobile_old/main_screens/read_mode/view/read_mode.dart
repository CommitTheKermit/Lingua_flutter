import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/models/bookmark_model.dart';
import 'package:lingua/screens_mobile/read_screen/view/read.dart';
import 'package:lingua/screens_mobile/read_screen/view_model/read_prov.dart';
import 'package:lingua/screens_mobile_old/bookmark_list_dialog.dart';

import 'package:lingua/screens_mobile_old/etc_screens/read_option/view/read_option_screen.dart';
import 'package:lingua/screens_mobile_old/main_screens/read_screen.dart';

import 'package:lingua/utils/bookmark_process/bookmark_util.dart';
import 'package:lingua/utils/etc/error_toast.dart';
import 'package:lingua/utils/shared_preferences/preferences.dart';
import 'package:lingua/utils/string_process/pager.dart';
import 'package:lingua/widgets/commons/common_text.dart';
import 'package:lingua/widgets/read_widgets/dialog/dialog_page_search.dart';
import 'package:lingua/widgets/read_widgets/dialog/search_list_dialog.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReadModeScreen extends StatefulWidget {
  const ReadModeScreen({
    super.key,
    required this.readProv,
  });

  final ReadProv readProv;

  @override
  State<ReadModeScreen> createState() => _ReadModeScreenState();
}

class _ReadModeScreenState extends State<ReadModeScreen>
    with TickerProviderStateMixin {
  bool _showMenu = false;
  late AnimationController _controller;
  late Animation<Offset> _topMenuOffset;
  late Animation<Offset> _bottomMenuOffset;
  late TextStyle readTextStyle;
  List<String> pages = [];
  double index = 0;

  late Future<String> futureOption;

  List<BookmarkModel> bookmarks = [];
  Set<int> bookmarkedLines = {};

  Future<String> initOption() async {
    await widget.readProv.model.readModeOption
        .loadOption(key: 'readModeOption');
    index = double.parse(await getPrefString('readModeIndex') ?? '0');

    bookmarks = await loadBookmarks();

    readTextStyle = TextStyle(
      color: Color(widget.readProv.model.readModeOption.optFontColor),
      fontSize: widget.readProv.model.readModeOption.optFontSize,
      fontFamily: widget.readProv.model.readModeOption.optFontFamily,
      height: widget.readProv.model.readModeOption.optFontHeight,
    );

    pages = paginateText(
        text: stringContents,
        style: readTextStyle,
        screenSize: Size(100.w, 100.h));

    return 'done';
  }

  void buildInit() {
    bookmarkedLines =
        bookmarks.map((bookmark) => bookmark.bookMarkedLine).toSet();
  }

  @override
  void initState() {
    super.initState();

    futureOption = initOption();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _topMenuOffset = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(_controller);

    _bottomMenuOffset = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0.865),
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    buildInit();

    // ShowMoreTextPopup popup = ShowMoreTextPopup(context,
    // text: text,
    // textStyle: const TextStyle(color: Colors.black),
    // height: 200,
    // width: 100,
    // backgroundColor: const Color(0xFF16CCCC),
    // padding: const EdgeInsets.all(4.0),
    // borderRadius: BorderRadius.circular(10.0));

    // print('\n\n'.isEmpty.toString());
    return FutureBuilder(
      future: futureOption,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          List splitted = pages[index.toInt()].split(RegExp(r"[ ]"));
          // print(splitted);
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: GestureDetector(
              onTap: () {
                setState(() {
                  _showMenu = !_showMenu;
                  if (_showMenu) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
                  }
                });
              },
              onVerticalDragEnd: (details) async {
                setState(() {
                  //upward
                  if (details.primaryVelocity! > 100 && index > 0) {
                    index -= 1;
                  }

                  // Swiping in downward direction.
                  if (details.primaryVelocity! < 100 && index < pages.length) {
                    index += 1;
                  }
                });
                await setPrefString('readModeIndex', index.toString());
              },
              child: Stack(
                children: [
                  Container(
                    width: 100.h,
                    height: 100.h,
                    decoration: BoxDecoration(
                      color: Color(widget
                          .readProv.model.readModeOption.optBackgroundColor),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 0),
                          // child: InteractableTextsWidget(
                          //     readTextStyle: readTextStyle, splitted: splitted),
                          child: Center(
                            child: Text(
                              pages[index.toInt()],
                              style: readTextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SlideTransition(
                    position: _topMenuOffset,
                    child: Opacity(
                      opacity: 0.9,
                      child: Container(
                        width: 100.w,
                        height: MediaQuery.of(context).padding.top + 6.h,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8F9FA),
                          border: Border(
                            bottom:
                                BorderSide(width: 1, color: Color(0xFFDEE2E6)),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Image.asset(
                                  "assets/images/icon_back.png",
                                  height: 3.h,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                tooltip: MaterialLocalizations.of(context)
                                    .openAppDrawerTooltip,
                              ),
                              SizedBox(
                                width: 40.w,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: comnText(
                                    labelText: titleNovel, // 파일 제목 출력
                                    fontSize: 2.5.h,
                                    fontColor: const Color(0xFF1E4A75),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Image.asset(
                                        bookmarkedLines.contains(index.toInt())
                                            ? "assets/images/icon_colored_bookmark.png"
                                            : "assets/images/icon_bookmark.png",
                                        height: 3.h,
                                      ),
                                      onPressed: () {
                                        if (!bookmarkedLines
                                            .contains(index.toInt())) {
                                          BookmarkModel bookmark =
                                              BookmarkModel(
                                                  bookMarkedLine: index.toInt(),
                                                  bookMarkedPage:
                                                      pages[index.toInt()],
                                                  bookMarkedTime:
                                                      DateTime.now());

                                          bookmarks.add(bookmark);
                                        } else {
                                          bookmarks.removeWhere((element) =>
                                              element.bookMarkedLine ==
                                              index.toInt());
                                        }

                                        saveBookmarks(bookmarks);
                                        setState(() {});
                                      },
                                    ),
                                    IconButton(
                                      icon: Image.asset(
                                          "assets/images/search_button.png",
                                          height: 3.h),
                                      onPressed: () async {
                                        String? result = await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SearchListDialog(
                                              pages: pages,
                                            );
                                          },
                                        );
                                        if (result != null) {
                                          if (result.startsWith('move')) {
                                            setState(() {
                                              String tempResult =
                                                  result.substring(
                                                      result.indexOf(':') + 1);

                                              index = double.parse(tempResult);
                                            });
                                          }
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: Image.asset(
                                        "assets/images/coloured_icon_read_setting.png",
                                        height: 3.h,
                                      ),
                                      onPressed: () async {
                                        errorToast(
                                            argText:
                                                '폰트 설정 변경시 북마크 페이지가 달라질 수 있습니다.');
                                        String? result = await Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              var begin =
                                                  const Offset(0.0, 0.0);
                                              var end = Offset.zero;
                                              var curve = Curves.ease;
                                              var tween = Tween(
                                                      begin: begin, end: end)
                                                  .chain(
                                                      CurveTween(curve: curve));
                                              return SlideTransition(
                                                position:
                                                    animation.drive(tween),
                                                child: child,
                                              );
                                            },
                                            pageBuilder: (context, anmation,
                                                    secondaryAnimation) =>
                                                ReadOptionScreen(
                                              startingTab: 3,
                                              readProv: widget.readProv,
                                            ),
                                          ),
                                        );
                                        if (result != null) {
                                          await initOption();

                                          pages = paginateText(
                                              text: stringContents,
                                              style: readTextStyle,
                                              screenSize: Size(100.w, 100.h));

                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SlideTransition(
                    position: _bottomMenuOffset,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Opacity(
                        opacity: 0.9,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFF8F9FA),
                            border: Border(
                              top: BorderSide(
                                  width: 1, color: Color(0xFFDEE2E6)),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        labelText:
                                            '현재 문서내 책갈피 ${bookmarkedLines.length}개',
                                        fontSize: 2.h,
                                        fontWeight: FontWeight.w500,
                                        fontColor: const Color(0xFF1E4A75),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      String? result = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return BookmarkListDialog(
                                            bookmarks: bookmarks,
                                          );
                                        },
                                      );
                                      if (result != null) {
                                        if (result.startsWith('move')) {
                                          setState(() {
                                            String tempResult =
                                                result.substring(
                                                    result.indexOf(':') + 1);

                                            index = double.parse(tempResult);
                                          });
                                        }
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        comnText(
                                          labelText: '책갈피 목록',
                                          fontSize: 1.5.h,
                                          fontWeight: FontWeight.w400,
                                          fontColor: const Color(0xFF1E4A75),
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
                                          thumbShape: RoundSliderThumbShape(
                                              enabledThumbRadius: 1.h)),
                                      child: Slider(
                                        activeColor: const Color(0xFF44698F),
                                        thumbColor: const Color(0xFF1F4A76),
                                        value: index,
                                        onChanged: (value) {
                                          setState(() {
                                            index = value;
                                          });
                                        },
                                        min: 0,
                                        max: (pages.length - 1).toDouble(),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      String result = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return DialogPageSearch(
                                            index: index.toInt(),
                                            pages: pages,
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

                                        index = double.parse(result);
                                      });
                                    },
                                    child: Container(
                                      width: 30.w,
                                      height: 4.5.h,
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              width: 0.5,
                                              color: Color(0xFF868E96)),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            comnText(
                                              labelText:
                                                  index.toStringAsFixed(0),
                                              fontColor:
                                                  const Color(0xFF1E4A75),
                                              fontSize: 2.25.h,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            comnText(
                                              labelText: "/${pages.length - 1}",
                                              fontColor:
                                                  const Color(0xFF868E96),
                                              fontSize: 2.25.h,
                                              fontWeight: FontWeight.w700,
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
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
