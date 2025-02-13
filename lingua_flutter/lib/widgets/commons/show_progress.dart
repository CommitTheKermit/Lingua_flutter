import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/main/main_theme.dart';
import 'package:lingua/widgets/commons/common.dart';
import 'package:lingua/widgets/commons/common_widget.dart';

/// 프로그래스바 출력
Future showProgress() async {
  return await showDialog(
      context: globalContext,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: comnLoading(),
            );
          }));
}

Future<dynamic> showFutureProgress({
  required Future futureFn,
}) async {
  bool didFinished = false;

  // // Future에 timeout 추가
  // Future timedFuture = futureFn.timeout(
  //   const Duration(seconds: 10),
  //
  //
  //   onTimeout: () {
  //     // 타임아웃 시에 발생할 예외
  //     comnLog('Timeout');
  //     showToast('비정상적인 작업입니다.');
  //
  //     throw TimeoutException('작업이 너무 오래 걸렸습니다.');
  //
  //   },
  // );

  return await showDialog(
    context: navKey.currentContext!,
    barrierDismissible: false,
    builder: (context) => FutureBuilder(
      future: futureFn,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: MAIN_APP_COLOR,
            ),
          );
        } else if (snapshot.hasData) {
          if (!didFinished) {
            didFinished = true;
            Future.delayed(Duration.zero, () {
              Navigator.pop(navKey.currentContext!, snapshot.data);
            });
          }

          comnLog("Successfully returned from showFutureProgress ${snapshot.data}");
          return const Center(
              child: CircularProgressIndicator(
            color: MAIN_APP_COLOR,
          ));
        } else if (snapshot.hasError) {
          comnLog("Error from showProgress ${snapshot.error}");
          FlutterError.reportError(FlutterErrorDetails(
            exception: snapshot.error.toString(),
          ));
          Navigator.pop(navKey.currentContext!);
          return const Center(
              child: CircularProgressIndicator(
            color: MAIN_APP_COLOR,
          ));
        } else {
          // 그 외 모든 경우
          return const Center(
              child: CircularProgressIndicator(
            color: MAIN_APP_COLOR,
          ));
        }
      },
    ),
  );
}

Future<bool> showFutureProgressBool({
  required Future<bool> futureFn,
}) async {
  bool didFinished = false;
  return await showDialog(
    context: navKey.currentContext!,
    barrierDismissible: false,
    builder: (context) => FutureBuilder(
      future: futureFn,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          if (!didFinished) {
            didFinished = true;
            Future.delayed(Duration.zero, () {
              Navigator.pop(navKey.currentContext!, snapshot.data);
            });
          }

          comnLog("Successfully returned from showFutureProgress ${snapshot.data}");
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          comnLog("Error from showProgress ${snapshot.error}");
          FlutterError.reportError(FlutterErrorDetails(
            exception: snapshot.error.toString(),
          ));
          Navigator.pop(navKey.currentContext!);
          return const Center(child: CircularProgressIndicator());
        } else {
          // 그 외 모든 경우
          return const Center(child: CircularProgressIndicator());
        }
      },
    ),
  );
}
