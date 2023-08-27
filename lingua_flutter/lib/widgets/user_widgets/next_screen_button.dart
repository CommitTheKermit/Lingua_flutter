import 'package:flutter/material.dart';

class NextScreenButton extends StatelessWidget {
  const NextScreenButton({
    super.key,
    required this.orangeColor,
    required this.inButtonText,
    required this.nextScreen,
    required this.navigatorAction,
  });

  final int orangeColor;
  final String inButtonText;
  final Widget nextScreen;
  final int navigatorAction;

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
      default:
        return const SizedBox.expand();
    }
  }
}
