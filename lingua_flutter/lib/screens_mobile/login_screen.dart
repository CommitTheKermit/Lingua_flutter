import 'package:flutter/material.dart';
import 'package:lingua/screens_mobile/read_screen.dart';
import 'package:lingua/util/exit_confirm.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static const int orangeColor = 0xFFF49349;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: () async {
          return exitConfirm(context);
        },
        child: const Padding(
          padding: EdgeInsets.only(
            left: 50,
            right: 50,
            top: 250,
          ),
          child: Column(
            children: [
              Text(
                'LINGUA',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Color(orangeColor),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              LoginField(
                hintText: "ID",
              ),
              SizedBox(
                height: 10,
              ),
              LoginField(
                hintText: "PW",
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LoginButton(
                      orangeColor: orangeColor,
                      inButtonText: 'Login',
                    ),
                    LoginButton(
                      orangeColor: orangeColor,
                      inButtonText: 'Signup',
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.orangeColor,
    required this.inButtonText,
  });

  final int orangeColor;
  final String inButtonText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
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
        child: Center(
          child: Text(
            inButtonText,
            style: const TextStyle(
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
