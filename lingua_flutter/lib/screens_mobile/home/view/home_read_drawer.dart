import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/screens_mobile/home/view_model/home_prov.dart';
import 'package:lingua/screens_mobile/read_mode/view/read_mode.dart';
import 'package:lingua/screens_mobile/read_option/view/read_option.dart';
import 'package:lingua/utils/etc/change_screen.dart';
import 'package:lingua/utils/etc/error_toast.dart';
import 'package:lingua/utils/file_process/file_process.dart';
import 'package:lingua/widgets/read_widgets/read_drawer.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeReadDrawer extends StatefulWidget {
  const HomeReadDrawer({super.key});

  @override
  State<HomeReadDrawer> createState() => _HomeReadDrawerState();
}

class _HomeReadDrawerState extends State<HomeReadDrawer> {
  @override
  Widget build(BuildContext context) {
    HomeProv readProv = Provider.of<HomeProv>(context);

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
            Scaffold.of(context).closeDrawer();
            try {
              showToast(argText: '.txt 파일만 불러올 수 있습니다.');
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
                    nextScreen: ReadModeScreen(
                      readProv: readProv,
                    ),
                    isReplace: false,
                  );
                }
              : () {
                  showToast(argText: '파일을 먼저 불러와주세요.');
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
                    ReadOptionScreen(
                  startingTab: 0,
                  readProv: readProv,
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
                  showToast(argText: '파일을 먼저 불러와주세요.');
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
              showToast(argText: '저장 완료. 다운로드 폴더를 확인해보세요!');
            } catch (e) {
              showToast(argText: '저장 오류 발생');
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
