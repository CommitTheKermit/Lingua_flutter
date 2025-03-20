import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/models/bookmark_model.dart';
import 'package:lingua/screens_mobile/home/view_model/home_prov.dart';
import 'package:lingua/screens_mobile/read_mode/view_model/read_mode_prov.dart';
import 'package:lingua/screens_mobile/read_option/view/read_option.dart';
import 'package:lingua/utils/bookmark_process/bookmark_util.dart';
import 'package:lingua/utils/string_process/pager.dart';
import 'package:lingua/widgets/commons/common.dart';
import 'package:lingua/widgets/commons/common_widget.dart';
import 'package:lingua/widgets/read_widgets/dialog/search_list_dialog.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReadModeTopBar extends StatefulWidget {
  const ReadModeTopBar({
    Key? key,
    required this.vsync,
  }) : super(key: key);
  final TickerProvider vsync;

  @override
  State<ReadModeTopBar> createState() => _ReadModeTopBarState();
}

class _ReadModeTopBarState extends State<ReadModeTopBar> {
  @override
  Widget build(BuildContext context) {
    ReadModeProv readProv = Provider.of<ReadModeProv>(context);
    HomeProv homeProv = Provider.of<HomeProv>(context);
    return SlideTransition(
      position: readProv.model.topMenuOffset,
      child: Opacity(
        opacity: 0.9,
        child: Container(
          width: 100.w,
          height: MediaQuery.of(context).padding.top + 6.h,
          decoration: const BoxDecoration(
            color: Color(0xFFF8F9FA),
            border: Border(
              bottom: BorderSide(width: 1, color: Color(0xFFDEE2E6)),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
                SizedBox(
                  width: 40.w,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: comnText(
                      titleNovel, // 파일 제목 출력
                      fontSize: 2.5.h,
                      colorFont: const Color(0xFF1E4A75),
                      weightFont: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Image.asset(
                          readProv.model.bookmarkedLines.contains(readProv.model.index.toInt())
                              ? "assets/images/icon_colored_bookmark.png"
                              : "assets/images/icon_bookmark.png",
                          height: 3.h,
                        ),
                        onPressed: () {
                          if (!readProv.model.bookmarkedLines
                              .contains(readProv.model.index.toInt())) {
                            BookmarkModel bookmark = BookmarkModel(
                                bookMarkedLine: readProv.model.index.toInt(),
                                bookMarkedPage: readProv.model.pages[readProv.model.index.toInt()],
                                bookMarkedTime: DateTime.now());

                            readProv.model.bookmarks.add(bookmark);
                          } else {
                            readProv.model.bookmarks.removeWhere((element) =>
                                element.bookMarkedLine == readProv.model.index.toInt());
                          }

                          saveBookmarks(readProv.model.bookmarks);
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: Image.asset("assets/images/search_button.png", height: 3.h),
                        onPressed: () async {
                          String? result = await showDialog(
                            context: context,
                            builder: (context) {
                              return SearchListDialog(
                                pages: readProv.model.pages,
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
                      ),
                      IconButton(
                        icon: Image.asset(
                          "assets/images/coloured_icon_read_setting.png",
                          height: 3.h,
                        ),
                        onPressed: () async {
                          showToast('폰트 설정 변경시 북마크 페이지가 달라질 수 있습니다.');
                          String? result = await Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                var begin = const Offset(0.0, 0.0);
                                var end = Offset.zero;
                                var curve = Curves.ease;
                                var tween =
                                    Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                              pageBuilder: (context, anmation, secondaryAnimation) =>
                                  const ReadOptionScreen(
                                startingTab: 3,
                              ),
                            ),
                          );
                          if (result != null) {
                            await readProv.firstLoad(
                              readModeOption: homeProv.model.readModeOption,
                              vsync: widget.vsync,
                            );

                            readProv.model.pages = paginateText(
                                text: stringContents,
                                style: readProv.model.readTextStyle,
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
    );
  }
}
