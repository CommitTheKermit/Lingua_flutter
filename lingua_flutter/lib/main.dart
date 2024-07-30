import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:lingua/screens_mobile/user_screens/login_screen.dart';
import 'package:permission_handler/permission_handler.dart';

int requestQuota = 0;
String titleNovel = "";
List<String> originalSentences = [];
String stringContents = "";
Map<String, String> trasJson = {};
Map<String, String> inputJson = {};

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const AppLingua());
}

class AppLingua extends StatefulWidget {
  const AppLingua({super.key});



  @override
  State<AppLingua> createState() => _AppLinguaState();
}

class _AppLinguaState extends State<AppLingua> {
  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    //권한 상태를 기록

    // var storageStatus = statuses[Permission.storage];

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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // ignore: deprecated_member_use

          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Noto Sans KR',
          primaryColor: const Color(0xFF1E4A75),
          highlightColor: const Color(0xFF1E4A75),
          hintColor: const Color(0xFF1E4A75),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFF1E4A75),
            selectionColor: Color(0xFF1E4A75),
            selectionHandleColor: Color(0xFF1E4A75),
          ),
          dialogBackgroundColor: Colors.white,
          dialogTheme: DialogTheme(
            surfaceTintColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          )),
      home: const LoginScreen(),
    );
  }
}
