import 'package:flutter/material.dart';

class NextScreenButton extends StatelessWidget {
  const NextScreenButton({
    super.key,
    required this.buttonColor,
    required this.inButtonText,
    required this.nextScreen,
    required this.navigatorAction,
    required this.buttonWidth,
    required this.textColor,
  });

  final Color buttonColor;
  final Color textColor;
  final String inButtonText;
  final Widget nextScreen;
  final int navigatorAction;
  final double? buttonWidth;

  @override
  Widget build(BuildContext context) {
    switch (navigatorAction) {
      case 0:
        {
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
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                  pageBuilder: (context, anmation, secondaryAnimation) =>
                      nextScreen,
                ),
              );
            },
            child: LoginButtonContainer(
                buttonWidth: buttonWidth,
                buttonColor: buttonColor,
                textColor: textColor,
                inButtonText: inButtonText),
          );
        }
      case 1:
        {
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
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                  pageBuilder: (context, anmation, secondaryAnimation) =>
                      nextScreen,
                ),
              );
            },
            child: LoginButtonContainer(
                buttonWidth: buttonWidth,
                buttonColor: buttonColor,
                textColor: textColor,
                inButtonText: inButtonText),
          );
        }
      default:
        return const SizedBox.expand();
    }
  }
}

class LoginButtonContainer extends StatelessWidget {
  const LoginButtonContainer({
    super.key,
    required this.buttonColor,
    required this.inButtonText,
    required this.buttonWidth,
    required this.textColor,
  });

  final Color buttonColor;
  final Color textColor;
  final String inButtonText;
  final double? buttonWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 50,
        width: buttonWidth,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
          border: Border.all(
            color: Colors.black,
            width: 0.5,
          ),
        ),
        child: Center(
          child: Text(
            inButtonText,
            style: TextStyle(
              color: textColor,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
