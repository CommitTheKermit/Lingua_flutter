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
    DeviceOrientation.portraitDown,
  ]);

  runApp(const AppLingua());
}

class AppLingua extends StatelessWidget {
  const AppLingua({super.key});

  static int requestQuota = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Noto Sans',
        primaryColor: const Color(0xFF8FC1E4),
        cardColor: const Color(0xFFF49349),
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: const Color(0xFFF49349),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
