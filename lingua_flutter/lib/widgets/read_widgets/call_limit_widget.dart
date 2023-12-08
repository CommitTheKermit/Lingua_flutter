import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/widgets/commons/common_text.dart';

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
        width: AppLingua.width * 2.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: AppLingua.width * 0.8,
              height: AppLingua.height * 0.05,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: AppLingua.width * 0.05,
                    ),
                    child: commonText(
                      labelText: '번역 제한',
                      fontColor: const Color(0xFF868E96),
                      fontSize: AppLingua.height * 0.02,
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: requestQuota,
                    builder: (context, value, child) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: AppLingua.width * 0.05,
                        ),
                        child: commonText(
                          labelText: "$value/200",
                          fontWeight: FontWeight.w400,
                          fontSize: AppLingua.height * 0.0225,
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
              width: AppLingua.width * 0,
            ),
            Container(
              width: AppLingua.width * 1.25,
              height: AppLingua.height * 0.05,
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
                          horizontal: AppLingua.width * 0.05),
                      child: Image.asset(
                        "assets/images/timer.png",
                        height: AppLingua.height * 0.033,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: AppLingua.width * 0.12,
                    ),
                    child: Image.asset(
                      "assets/images/timer_colored.png",
                      height: AppLingua.height * 0.033,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: AppLingua.width * 0.025),
                          child: commonText(
                            labelText: '번역 제한 충전까지',
                            fontColor: const Color(0xFF868E96),
                            fontSize: AppLingua.height * 0.02,
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(right: AppLingua.width * 0.05),
                          child: ValueListenableBuilder(
                            valueListenable: remainingTime,
                            builder: (context, value, child) {
                              String time = '${value ~/ 60}:${value % 60}';
                              return Text(
                                time,
                                style: TextStyle(
                                  fontSize: AppLingua.height / 30,
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
