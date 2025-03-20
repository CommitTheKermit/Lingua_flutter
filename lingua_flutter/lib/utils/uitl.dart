import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/utils/api_util.dart';
import 'package:lingua/widgets/commons/error_confirm_dialog.dart';

Future comnShowDialog({
  required Widget dialog,
  bool barrierDismissible = true,
}) async {
  return await showDialog(
    context: navKey.currentContext!,
    builder: (context) => dialog,
    barrierDismissible: barrierDismissible,
  );
}

Future comnApiPost({
  required String url,
  required dynamic body,
  required Function(Map<String, dynamic> result) onGet,
  required dynamic prov,
  String? urlHeader,
  Function()? errorHandle,
}) async {
  try {
    Map<String, dynamic> result = await apiPost(
      uri: url,
      body: body,
      urlHeader: urlHeader,
    );
    dynamic resultValue = await onGet.call(result);

    if (resultValue != null) {
      return resultValue;
    } else {
      return true;
    }
  } catch (e, stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: e,
        stack: stackTrace,
      ),
    );
    if (errorHandle == null) {
      await comnShowNetworkErrorDialog(onTap: () {
        prov.clear();
        prov.notify();
      });
    } else {
      errorHandle.call();
    }

    return false;
  }
}

Future comnShowNetworkErrorDialog({
  required Function() onTap,
  String? content,
}) async {
  return await comnShowDialog(
    barrierDismissible: false,
    dialog: ErrorConfirmDialog(
      title: '오류',
      content: content ?? '네트워크 연결에 실패하였습니다.\n다시 시도해 주세요',
      onTap: onTap,
    ),
  );
}

extension RequestResultJudge on Map {
  bool isSuccessful() {
    if (this['responseStatusCode'] >= 200 && this['responseStatusCode'] <= 300) {
      return true;
    } else {
      return false;
    }
  }
}
