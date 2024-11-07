import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lingua/main/main_provider.dart';
import 'package:lingua/main/main_theme.dart';
import 'package:lingua/mainframe/view/mainframe.dart';
import 'package:lingua/models/server_info.dart';
import 'package:lingua/screens_mobile/read_screen/view/read.dart';
import 'package:lingua/screens_mobile/read_screen/view_model/read_prov.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// static const String baseUrl = "http://10.0.2.2:8000";
const String baseUrl = ServerInfo.baseUrl;
const int timeoutSec = ServerInfo.timeoutSec;
String API_KEY = '';
int requestQuota = 0;
String titleNovel = "";
List<String> originalSentences = [];
String stringContents = "";
Map<String, String> trasJson = {};
Map<String, String> inputJson = {};
GlobalKey<NavigatorState> navKey = GlobalKey();
late BuildContext globalContext;
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
    MainTheme mainTheme = MainTheme(
      argContext: context,
    );

    return MaterialApp(
      navigatorKey: navKey,
      debugShowCheckedModeBanner: false,
      theme: mainTheme.theme,
      home: ResponsiveSizer(builder: (context, orientation, screenType) {
        return MainProvider(
          child: Mainframe(
              child: ReadScreen(
            readProv: Provider.of<ReadProv>(context, listen: false),
          )),
        );
      }),
    );
  }
}
