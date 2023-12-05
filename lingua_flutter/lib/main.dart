import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:lingua/screens_mobile/read_screen.dart';
import 'package:lingua/screens_mobile/user_screens/login_screen.dart';
import 'package:lingua/util/api/api_user.dart';
import 'package:lingua/util/api/api_util.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const AppLingua());
}

class AppLingua extends StatelessWidget {
  const AppLingua({super.key});

  static int requestQuota = 0;
  static Size size = const Size(0, 0);
  static double width = 0;
  static double height = 0;

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
