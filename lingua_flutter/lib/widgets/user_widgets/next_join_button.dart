import 'package:flutter/material.dart';
import 'package:lingua/widgets/commons/common_text.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
      child: Padding(
        padding: EdgeInsets.only(bottom: 3.h),
        child: Container(
          width: 90.w,
          height: 6.25.h,
          decoration: ShapeDecoration(
            color: const Color(0xFF1E4A75),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          child: Center(
            child: commonText(
              labelText: inButtonText,
              fontSize: 2.25.h,
              fontWeight: FontWeight.w700,
              fontColor: const Color(0xFFF8F9FA),
            ),
          ),
        ),
      ),
    );
  }
}
