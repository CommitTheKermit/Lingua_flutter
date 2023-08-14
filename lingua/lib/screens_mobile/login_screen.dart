import 'package:flutter/material.dart';
import 'package:lingua/screens_mobile/read_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static const int orangeColor = 0xFFF49349;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: 50,
          right: 50,
          top: 250,
        ),
        child: Column(
          children: [
            const Text(
              'LINGUA',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: Color(orangeColor),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const LoginField(
              hintText: "ID",
            ),
            const SizedBox(
              height: 10,
            ),
            const LoginField(
              hintText: "PW",
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const LoginButton(orangeColor: orangeColor),
                  Container(
                    height: 50,
                    width: 120,
                    decoration: const BoxDecoration(
                      color: Color(orangeColor),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.orangeColor,
  });

  final int orangeColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = const Offset(0.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
            pageBuilder: (context, anmation, secondaryAnimation) =>
                const ReadScreen(),
          ),
        );
      },
      child: Container(
        height: 50,
        width: 120,
        decoration: BoxDecoration(
          color: Color(orangeColor),
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: const Center(
          child: Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class LoginField extends StatelessWidget {
  final String hintText;
  const LoginField({
    super.key,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: hintText,
        ),
      ),
    );
  }
}
