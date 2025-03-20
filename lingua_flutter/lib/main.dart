import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lingua/main/main_setting.dart';
import 'package:lingua/models/user_model.dart';
import 'package:lingua/provider/main_provider.dart';
import 'package:lingua/main/main_theme.dart';
import 'package:lingua/mainframe/view/mainframe.dart';
import 'package:lingua/screens_mobile/login/view/login.dart';
import 'package:lingua/screens_mobile/login/view_model/login_prov.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// static const String baseUrl = "http://10.0.2.2:8000";
String API_KEY = '';
int requestQuota = 0;
String titleNovel = "";
List<String> originalSentences = [];
String stringContents = "";
Map<String, String> trasJson = {};
Map<String, String> inputJson = {};
GlobalKey<NavigatorState> navKey = GlobalKey();
late BuildContext globalContext;
late String baseApiUrl;
UserModel user = UserModel();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); //가로모드 막기
  ///앱 내부 오류 보고, 빨간색 오류 화면, 내부 오류, 익셉션
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    // comnLog((details.exception as DioException).response);
  };

  await mainSetting();

  runApp(const AppLingua());
}

class AppLingua extends StatefulWidget {
  const AppLingua({super.key});

  @override
  State<AppLingua> createState() => _AppLinguaState();
}

class _AppLinguaState extends State<AppLingua> {
  @override
  void initState() {
    Permission.storage.request();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MainTheme mainTheme = MainTheme(
      argContext: context,
    );

    return MainProvider(
      child: MaterialApp(
        navigatorKey: navKey,
        debugShowCheckedModeBanner: false,
        theme: mainTheme.theme,

        ///로컬 한글로 세팅
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          // SfGlobalLocalizations.delegate
        ],
        supportedLocales: const [
          Locale('ko', 'KR'),
        ],
        initialRoute: '/',
        routes: {
          '/': (context) => Mainframe(
                child:
                    ChangeNotifierProvider(create: (context) => LoginProv(), child: LoginScreen()),
              ),
        },
        builder: (context, child) => ResponsiveSizer(
          builder: (context, orientation, screenType) {
            return Stack(
              children: [
                Overlay(
                  initialEntries: [
                    if (child != null) ...[
                      OverlayEntry(
                        builder: (context) => child,
                      ),
                    ],
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
