import 'package:fluttertoast/fluttertoast.dart';

DateTime? currentBackPressTime;

Future<bool> onWillPop() {
  DateTime now = DateTime.now();

  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
    currentBackPressTime = now;
    const msg = "뒤로 버튼을 한 번 더 눌러 종료합니다.";

    Fluttertoast.showToast(msg: msg);
    return Future.value(false);
  }

  return Future.value(true);
}
