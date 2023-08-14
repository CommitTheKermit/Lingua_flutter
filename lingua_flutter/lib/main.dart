import 'package:flutter/material.dart';

import 'screens_mobile/login_screen.dart';

void main() {
  runApp(const AppLingua());
}

class AppLingua extends StatelessWidget {
  const AppLingua({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: const Color(0xFFF49349),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFFF49349),
          ),
        ),
        cardColor: const Color(0xFFF49349),
        
      ),
      home: const LoginScreen(),
    );
  }
}
