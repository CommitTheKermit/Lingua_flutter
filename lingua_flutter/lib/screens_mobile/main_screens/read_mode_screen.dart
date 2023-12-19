import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/models/bookmark_model.dart';
import 'package:lingua/screens_mobile/bookmark_list_dialog.dart';

import 'package:lingua/screens_mobile/etc_screens/read_option_screen.dart';
import 'package:lingua/screens_mobile/interactable_page_widget.dart';
import 'package:lingua/screens_mobile/main_screens/read_screen.dart';

import 'package:lingua/util/bookmark_process/bookmark_util.dart';
import 'package:lingua/util/etc/error_toast.dart';
import 'package:lingua/util/shared_preferences/preference_manager.dart';
import 'package:lingua/util/string_process/pager.dart';
import 'package:lingua/widgets/commons/common_text.dart';
import 'package:lingua/widgets/read_widgets/dialog/dialog_page_search.dart';
import 'package:lingua/widgets/read_widgets/dialog/search_list_dialog.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';

class ReadModeScreen extends StatefulWidget {
  const ReadModeScreen({super.key});

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
    await ReadScreen.readModeOption.loadOption(key: 'readModeOption');
    index =
        double.parse(await PreferenceManager.getValue('readModeIndex') ?? '0');

    bookmarks = await loadBookmarks();

    readTextStyle = TextStyle(
      color: Color(ReadScreen.readModeOption.optFontColor),
      fontSize: ReadScreen.readModeOption.optFontSize,
      fontFamily: ReadScreen.readModeOption.optFontFamily,
      height: ReadScreen.readModeOption.optFontHeight,
    );

    pages = paginateText(
        text: AppLingua.stringContents,
        style: readTextStyle,
        screenSize: AppLingua.size);

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
                await PreferenceManager.saveValue(
                    'readModeIndex', index.toString());
              },
              child: Stack(
                children: [
                  Container(
                    width: AppLingua.height,
                    height: AppLingua.height,
                    decoration: BoxDecoration(
                      color:
                          Color(ReadScreen.readModeOption.optBackgroundColor),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppLingua.width * 0.04,
                              vertical: AppLingua.height * 0),
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
                        width: AppLingua.width,
                        height: MediaQuery.of(context).padding.top +
                            AppLingua.height * 0.06,
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
                                  height: AppLingua.height * 0.03,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                tooltip: MaterialLocalizations.of(context)
                                    .openAppDrawerTooltip,
                              ),
                              SizedBox(
                                width: AppLingua.width * 0.4,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: commonText(
                                    labelText: AppLingua.titleNovel, // 파일 제목 출력
                                    fontSize: AppLingua.height * 0.025,
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
                                        height: AppLingua.height * 0.03,
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
                                        height: AppLingua.height * 0.03,
                                      ),
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
                                        height: AppLingua.height * 0.03,
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
                                                const ReadOptionScreen(
                                              startingTab: 3,
                                            ),
                                          ),
                                        );
                                        if (result != null) {
                                          await initOption();

                                          pages = paginateText(
                                              text: AppLingua.stringContents,
                                              style: readTextStyle,
                                              screenSize: AppLingua.size);

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
                                left: AppLingua.width * 0.05,
                                right: AppLingua.width * 0.05,
                                top: AppLingua.height * 0.018,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/icon_bookmarks.png",
                                        height: AppLingua.height * 0.03,
                                      ),
                                      SizedBox(
                                        width: AppLingua.width * 0.022,
                                      ),
                                      commonText(
                                        labelText:
                                            '현재 문서내 책갈피 ${bookmarkedLines.length}개',
                                        fontSize: AppLingua.height * 0.02,
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
                                        commonText(
                                          labelText: '책갈피 목록',
                                          fontSize: AppLingua.height * 0.015,
                                          fontWeight: FontWeight.w400,
                                          fontColor: const Color(0xFF1E4A75),
                                        ),
                                        Image.asset(
                                          'assets/images/icon_small_arrow.png',
                                          height: AppLingua.height * 0.015,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: AppLingua.width * 0.05,
                                right: AppLingua.width * 0.05,
                                top: AppLingua.height * 0.018,
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/icon_text.png',
                                    height: AppLingua.height * 0.03,
                                  ),
                                  SizedBox(
                                    width: AppLingua.width * 0.5,
                                    height: AppLingua.height * 0.01875,
                                    child: SliderTheme(
                                      data: SliderThemeData(
                                          thumbShape: RoundSliderThumbShape(
                                              enabledThumbRadius:
                                                  AppLingua.height * 0.01)),
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
                                        // originalSingleSentence = AppLingua.originalSentences[index];
                                        // words = extractWords(originalSingleSentence);
                                        // _scrollController.jumpTo(0);

                                        index = double.parse(result);
                                      });
                                    },
                                    child: Container(
                                      width: AppLingua.width * 0.3,
                                      height: AppLingua.height * 0.045,
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
                                            commonText(
                                              labelText:
                                                  index.toStringAsFixed(0),
                                              fontColor:
                                                  const Color(0xFF1E4A75),
                                              fontSize:
                                                  AppLingua.height * 0.0225,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            commonText(
                                              labelText: "/${pages.length - 1}",
                                              fontColor:
                                                  const Color(0xFF868E96),
                                              fontSize:
                                                  AppLingua.height * 0.0225,
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
