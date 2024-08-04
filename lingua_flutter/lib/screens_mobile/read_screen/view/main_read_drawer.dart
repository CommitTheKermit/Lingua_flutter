import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/screens_mobile/read_screen/view_model/read_screen_prov.dart';
import 'package:lingua/screens_mobile_old/etc_screens/read_option_screen.dart';
import 'package:lingua/screens_mobile_old/main_screens/read_mode_screen.dart';
import 'package:lingua/utils/etc/change_screen.dart';
import 'package:lingua/utils/etc/error_toast.dart';
import 'package:lingua/utils/file_process/file_process.dart';
import 'package:lingua/widgets/read_widgets/read_drawer.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MainReadDrawer extends StatefulWidget {
  const MainReadDrawer({super.key});

  @override
  State<MainReadDrawer> createState() => _MainReadDrawerState();
}

class _MainReadDrawerState extends State<MainReadDrawer> {
  @override
  Widget build(BuildContext context) {
    ReadScreenProv readProv = Provider.of<ReadScreenProv>(context);
    
      return ReadDrawer(
      listTiles: [
        ListTile(
          leading: Image.asset(
            'assets/images/icon_file_read.png',
            width: 3.h,
          ),
          title: const Text(
            '파일 읽기',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onTap: () async {
            try {
              errorToast(argText: '.txt 파일만 불러올 수 있습니다.');
              Navigator.pop(context);
              originalSentences = await filePickAndRead();
              readProv.loadInitialIndex();
            } catch (e) {}
          },
        ),
        ListTile(
          leading: Image.asset(
            'assets/images/icon_read_mode.png',
            width: 3.h,
          ),
          title: const Text(
            '뷰어 모드',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onTap: readProv.model.isNovelLoaded
              ? () {
                  Navigator.pop(context);
                  changeScreen(
                    context: context,
                    nextScreen: const ReadModeScreen(),
                    isReplace: false,
                  );
                }
              : () {
                  errorToast(argText: '파일을 먼저 불러와주세요.');
                },
        ),
        ListTile(
          leading: Image.asset(
            'assets/images/icon_read_setting.png',
            width: 3.h,
          ),
          title: const Text(
            '옵션',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onTap: () async {
            Navigator.pop(context);
            String? result = await Navigator.push(
              context,
              PageRouteBuilder(
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(0.0, 0.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
                pageBuilder: (context, anmation, secondaryAnimation) =>
                    const ReadOptionScreen(
                  startingTab: 0,
                ),
              ),
            );
            if (result != null) {
              await readProv.initOption();
            }
          },
        ),
        ListTile(
          leading: Image.asset(
            'assets/images/icon_line_change.png',
            width: 3.h,
          ),
          title: const Text(
            '줄 이동',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onTap: readProv.model.isNovelLoaded
              ? () {
                  Navigator.pop(context);
                  readProv.lineSearchDialog(
                    context: context,
                    argIndex: readProv.model.index,
                  );
                }
              : () {
                  errorToast(argText: '파일을 먼저 불러와주세요.');
                },
        ),
        ListTile(
          leading: Image.asset(
            'assets/images/icon_download.png',
            width: 3.h,
          ),
          title: const Text(
            '기록 추출',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onTap: () async {
            try {
              await saveFile(fileName: 'fileName');
              errorToast(argText: '저장 완료. 다운로드 폴더를 확인해보세요!');
            } catch (e) {
              errorToast(argText: '저장 오류 발생');
            }
          },
        ),
        // ListTile(
        //   leading: Image.asset(
        //     'assets/images/icon_wordbook.png',
        //     width: height * 0.03,
        //   ),
        //   title: const Text(
        //     '단어장',
        //     style: TextStyle(
        //       fontSize: 16,
        //     ),
        //   ),
        //   onTap: () {
        //     errorToast(argText: '준비중.');
        //   },
        // ),
      ],
    );
  }
}