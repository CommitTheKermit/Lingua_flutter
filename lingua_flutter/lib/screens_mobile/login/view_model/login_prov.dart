import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/screens_mobile/login/model/login_model.dart';
import 'package:lingua/utils/shared_preferences/preferences.dart';
import 'package:lingua/utils/uitl.dart';
import 'package:lingua/widgets/commons/common_widget.dart';

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
      bool isEmailRecord = getPrefBool('isEmailRecord') ?? false;

      model.recordedEmail = getPrefString('email');
      if (model.recordedEmail == null) {
        model.isEmailRecord = false;
        return 'error';
      } else {
        model.controller.text = model.recordedEmail!;
      }

      model.isEmailRecord = isEmailRecord;
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
          comnLog(result);
          return true;
        } else {
          return false;
        }
      },
    );
  }
}
