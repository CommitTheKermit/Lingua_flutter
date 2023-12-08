import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:lingua/screens_mobile/read_screen.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const AppLingua());
}

class AppLingua extends StatefulWidget {
  const AppLingua({super.key});

  static int requestQuota = 0;
  static Size size = const Size(0, 0);
  static double width = 0;
  static double height = 0;
  static String titleNovel = "";
  static List<String> originalSentences = [];
  static String stringContents = "";
  static Map<String, String> trasJson = {};
  static Map<String, String> inputJson = {};

  @override
  State<AppLingua> createState() => _AppLinguaState();
}

class _AppLinguaState extends State<AppLingua> {
  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    //권한 상태를 기록

    var storageStatus = statuses[Permission.storage];

    // if (cameraStatus!.isGranted &&
    //     microphoneStatus!.isGranted &&
    //     storageStatus!.isGranted) {
    //   // 모든 권한이 허용될시에 실행할 코드
    // } else {
    //   // 하나 이상의 권한이 거부될시에 실행할 코드
    // }
  }

  @override
  void initState() {
    requestPermissions();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLingua.size = MediaQuery.of(context).size;
    AppLingua.width = MediaQuery.of(context).size.width;
    AppLingua.height = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Noto Sans KR',
      ),
      home: const ReadScreen(),
    );
  }
}
