import 'package:flutter/material.dart';
import 'package:lingua/screens_mobile/home/view/appbar/input_allow_button.dart';
import 'package:lingua/screens_mobile/home/view/appbar/translate_allow_button.dart';
import 'package:lingua/screens_mobile/home/view_model/home_prov.dart';
import 'package:lingua/widgets/commons/common_text.dart';
import 'package:lingua/widgets/read_widgets/dialog/dialog_word_search.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    HomeProv readProv = Provider.of<HomeProv>(context);
    return AppBar(
      elevation: 0,
      // foregroundColor: const Color(0xFFF8F9FA),
      backgroundColor: Colors.white,

      // backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      shape: const Border(
        bottom: BorderSide(width: 1, color: Color(0xFFDEE2E6)),
      ),

      // No text styles in this selection

      actions: [
        SizedBox(
          width: 100.w,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 1.w),
                child: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: Image.asset(
                        "assets/images/sort_button.png",
                        height: 3.h,
                        width: 3.h,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer(); // Drawer를 엽니다.
                      },
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip,
                    );
                  },
                ),
              ),
              SizedBox(
                width: 40.w,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: comnText(
                    labelText: readProv.model.titleNovel.isNotEmpty // 파일 제목 출력
                        ? readProv.model.titleNovel
                        : '파일을 선택해주세요.',
                    fontSize: 2.5.h,
                    fontColor: const Color(0xFF1E4A75),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                child: Row(
                  children: [
                    InputAllowButton(
                      onPressedCallback: () {
                        setState(() {});
                      },
                      assetName: "assets/images/edit_button.png",
                      iconSize: 3.h,
                    ),
                    TranslateAllowButton(
                      onPressedCallback: () {
                        setState(() {});
                        if (readProv.model.isNovelLoaded) {
                          readProv.lineShift(shiftAmount: 0);
                        }
                      },
                      assetName: "assets/images/translate_button.png",
                      iconSize: 3.h,
                    ),
                    IconButton(
                      iconSize: 20,
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return const DialogWordSearch();
                          },
                        );
                      },
                      icon: Image.asset(
                        "assets/images/search_button.png",
                        height: 3.h,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 문맥 탐색 대화상자
        // IconButton(
        //   iconSize: 30,
        //   onPressed: () {
        //     showDialog(
        //       context: context,
        //       barrierDismissible: true,
        //       builder: (context) {
        //         return DialogContextWidget(index: index);
        //       },
        //     );
        //   },
        //   icon: const Icon(Icons.menu_book_rounded),
        //   color: Colors.white,
        // ),
      ],

      // title을 null로 설정
      // flexibleSpace: LayoutBuilder(
      //   builder: (BuildContext context, BoxConstraints constraints) {
      //     return FlexibleSpaceBar(
      //       title: SizedBox(
      //         width: width / 2,
      //         child: SingleChildScrollView(
      //           scrollDirection: Axis.horizontal,
      //           child: commonText(
      //             labelText: titleNovel.isNotEmpty // 파일 제목 출력
      //                 ? titleNovel
      //                 : '파일을 선택해주세요.',
      //             fontSize: height * 0.025,
      //             fontColor: const Color(0xFF1E4A75),
      //           ),
      //         ),
      //       ),
      //       titlePadding: EdgeInsets.only(
      //           left: 50, top: height * 0.03), // 원하는 위치로 조절
      //     );
      //   },
      // ),
    );
  }
}
