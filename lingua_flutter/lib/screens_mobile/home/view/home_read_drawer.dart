import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/screens_mobile/home/view_model/home_prov.dart';
import 'package:lingua/screens_mobile/read_mode/view/read_mode.dart';
import 'package:lingua/screens_mobile/read_mode/view_model/read_mode_prov.dart';
import 'package:lingua/screens_mobile/read_option/view/read_option.dart';
import 'package:lingua/utils/etc/change_screen.dart';
import 'package:lingua/utils/file_process/file_process.dart';
import 'package:lingua/widgets/commons/common_widget.dart';
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
    HomeProv homeProv = Provider.of<HomeProv>(context);

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
              showToast('.txt 파일만 불러올 수 있습니다.');
              originalSentences = await filePickAndRead();
              homeProv.loadInitialIndex();
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
          onTap: homeProv.model.isNovelLoaded
              ? () async {
                  Navigator.pop(context);
                  await changeScreen(
                    nextScreen: ChangeNotifierProvider(
                      create: (_) => ReadModeProv(),
                      child: ReadModeScreen(),
                    ),
                    isReplace: false,
                  );
                }
              : () {
                  showToast('파일을 먼저 불러와주세요.');
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
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(0.0, 0.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;
                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
                pageBuilder: (context, anmation, secondaryAnimation) => const ReadOptionScreen(
                  startingTab: 0,
                ),
              ),
            );
            if (result != null) {
              await homeProv.firstLoad();
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
          onTap: homeProv.model.isNovelLoaded
              ? () {
                  Navigator.pop(context);
                  homeProv.lineSearchDialog(
                    context: context,
                    argIndex: homeProv.model.index,
                  );
                }
              : () {
                  showToast('파일을 먼저 불러와주세요.');
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
              showToast('저장 완료. 다운로드 폴더를 확인해보세요!');
            } catch (e) {
              showToast('저장 오류 발생');
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
