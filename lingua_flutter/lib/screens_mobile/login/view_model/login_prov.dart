import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/screens_mobile/home/view/home.dart';
import 'package:lingua/screens_mobile/login/model/login_model.dart';
import 'package:lingua/utils/etc/change_screen.dart';
import 'package:lingua/utils/shared_preferences/preferences.dart';
import 'package:lingua/utils/shared_preferences/prefs.dart';
import 'package:lingua/utils/uitl.dart';
import 'package:lingua/widgets/commons/common_widget.dart';
import 'package:lingua/widgets/commons/comn_dialog.dart';

class LoginProv extends ChangeNotifier {
  LoginModel model = LoginModel();

  void clear() {
    model = LoginModel();
  }

  void notify() {
    notifyListeners();
  }

  Future firstLoad() async {
    try {
      ///자동 로그인 옵션 검사
      model.isAutoLogin = (getPrefBool('isAutoLogin') ?? false);
      if (getPrefString('authToken') != null && model.isAutoLogin) {
        bool result = await autoLogin();
        if (result) {
          await changeScreen(
            nextScreen: const HomeScreen(),
            isReplace: true,
          );
          return 'autoLogin';
        }
      }

      model.recordedEmail = getPrefString('email');
      if (model.recordedEmail == null) {
        model.isAutoLogin = false;
        return 'error';
      } else {
        model.controller.text = model.recordedEmail!;
      }
    } catch (e) {
      return 'error';
    }

    return 'done';
  }

  Future loginCall() async {
    return await comnApiPost(
      url: '/users/login',
      body: {
        'email': user.email,
        'password': user.password,
      },
      prov: this,
      onGet: (result) async {
        // comnLog(result);
        if (result.isSuccessful()) {
          // comnLog(result);
          setPrefString('authToken', result['authToken']);

          if (model.isAutoLogin) {
            setPrefBool('isAutoLogin', model.isAutoLogin);
            setPrefString('email', model.email);
          }

          return true;
        } else {
          clear();
          notify();
          comnShowDialog(
              dialog: const ComnDialog(
            type: ComnDialogType.single,
            title: '실패',
            contents: '입력 정보를 다시 확인해보세요.',
          ));
          return false;
        }
      },
    );
  }

  Future autoLogin() async {
    return await comnApiPost(
      // ignoreErrorHandle: true,
      url: '/users/validateToken',
      body: {
        'authToken': getPrefString('authToken'),
      },
      prov: this,
      onGet: (result) async {
        // comnLog(result);
        if (result['user_id'] != null) {
          comnLog(result);
          return true;
        } else {
          Prefs().remove('authToken');
          comnShowDialog(
              dialog: ComnDialog(
            type: ComnDialogType.single,
            title: '만료',
            contents: '자동 로그인 토큰이 만료 되었습니다.\n'
                '다시 로그인 해 주세요.',
            onRightTap: () {
              Navigator.pop(globalContext);
            },
          ));
          return false;
        }
      },
    );
  }

  Future afterLogin() async {}
}
