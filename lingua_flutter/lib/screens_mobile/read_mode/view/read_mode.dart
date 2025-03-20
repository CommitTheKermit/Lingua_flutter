import 'package:flutter/material.dart';
import 'package:lingua/screens_mobile/home/view_model/home_prov.dart';
import 'package:lingua/screens_mobile/read_mode/view/read_mode_bottom_bar.dart';
import 'package:lingua/screens_mobile/read_mode/view/read_mode_top_bar.dart';
import 'package:lingua/screens_mobile/read_mode/view_model/read_mode_prov.dart';
import 'package:lingua/utils/shared_preferences/preferences.dart';
import 'package:lingua/widgets/commons/common.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReadModeScreen extends StatefulWidget {
  const ReadModeScreen({
    super.key,
  });

  @override
  State<ReadModeScreen> createState() => _ReadModeScreenState();
}

class _ReadModeScreenState extends State<ReadModeScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    ReadModeProv readProv = Provider.of<ReadModeProv>(context);
    HomeProv homeProv = Provider.of<HomeProv>(context);

    readProv.model.futureLoad ??= readProv.firstLoad(
      readModeOption: homeProv.model.readModeOption,
      vsync: this,
    );

    readProv.model.bookmarkedLines =
        readProv.model.bookmarks.map((bookmark) => bookmark.bookMarkedLine).toSet();

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
      future: readProv.model.futureLoad,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return comnLoading();
        } else {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: GestureDetector(
              onTap: () {
                readProv.model.showMenu = !readProv.model.showMenu;
                if (readProv.model.showMenu) {
                  readProv.model.controller.forward();
                } else {
                  readProv.model.controller.reverse();
                }
                setState(() {});
              },
              onVerticalDragEnd: (details) async {
                //upward
                if (details.primaryVelocity! > 100 && readProv.model.index > 0) {
                  readProv.model.index -= 1;
                }

                // Swiping in downward direction.
                if (details.primaryVelocity! < 100 &&
                    readProv.model.index < readProv.model.pages.length) {
                  readProv.model.index += 1;
                }

                await setPrefString('readModeIndex', readProv.model.index.toString());
                setState(() {});
              },
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      width: 100.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                        color: Color(homeProv.model.readModeOption.optBackgroundColor),
                        // color: Colors.red
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0),
                                child: Text(
                                  readProv.model.pages[readProv.model.index.toInt()],
                                  style: readProv.model.readTextStyle,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ReadModeTopBar(vsync: this),
                  const ReadModeBottomBar(),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
