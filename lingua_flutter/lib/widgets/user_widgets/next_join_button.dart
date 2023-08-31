import 'package:flutter/material.dart';

class NextJoinButton extends StatelessWidget {
  const NextJoinButton({
    super.key,
    required this.isSent,
    required this.inButtonText,
    required this.nextScreen,
  });

  final bool isSent;
  final String inButtonText;
  final Widget nextScreen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSent
          ? () {
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
            }
          : () {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          color: isSent ? Theme.of(context).primaryColor : Colors.grey,
        ),
        child: Center(
            child: Text(
          inButtonText,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: 'Neo',
          ),
        )),
      ),
    );
  }
}
