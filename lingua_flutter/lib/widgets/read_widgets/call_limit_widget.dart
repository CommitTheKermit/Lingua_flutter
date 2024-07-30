import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/widgets/commons/common_text.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Widget callLimitWidget({
  required int callLimitFlex,
  required ScrollController scrollTimerController,
  required ValueListenable requestQuota,
  required ValueListenable remainingTime,
}) {
  return Flexible(
    flex: callLimitFlex,
    child: SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      controller: scrollTimerController,
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 210.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 80.w,
              height: 5.h,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 5.w,
                    ),
                    child: commonText(
                      labelText: '번역 제한',
                      fontColor: const Color(0xFF868E96),
                      fontSize: 2.h,
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: requestQuota,
                    builder: (context, value, child) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: 5.w,
                        ),
                        child: commonText(
                          labelText: "$value/200",
                          fontWeight: FontWeight.w400,
                          fontSize: 2.25.h,
                          fontColor: const Color(0xFF171A1D),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            VerticalDivider(
              thickness: 0,
              color: Colors.transparent,
              width: 0,
            ),
            Container(
              width: 125.w,
              height: 5.h,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  GestureDetector(
                    onTap: () {
                      scrollTimerController.animateTo(
                          scrollTimerController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.easeInOut);

                      Future.delayed(const Duration(seconds: 3), () {
                        scrollTimerController.animateTo(0,
                            duration: const Duration(milliseconds: 700),
                            curve: Curves.easeInOut);
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 5.w),
                      child: Image.asset(
                        "assets/images/timer.png",
                        height: 3.3.h,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 12.w,
                    ),
                    child: Image.asset(
                      "assets/images/timer_colored.png",
                      height: 3.3.h,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 2.5.w),
                          child: commonText(
                            labelText: '번역 제한 충전까지',
                            fontColor: const Color(0xFF868E96),
                            fontSize: 2.h,
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(right: 5.w),
                          child: ValueListenableBuilder(
                            valueListenable: remainingTime,
                            builder: (context, value, child) {
                              String time = '${value ~/ 60}:${value % 60}';
                              return Text(
                                time,
                                style: TextStyle(
                                  fontSize: 33.h,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
