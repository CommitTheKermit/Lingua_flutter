import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/screens_mobile/login_screens/signup/model/sigin_up_model.dart';
import 'package:lingua/utils/uitl.dart';
import 'package:lingua/widgets/commons/comn_dialog.dart';

class SignUpProv extends ChangeNotifier {
  SignUpModel model = SignUpModel();

  void clear() {
    model = SignUpModel();
  }

  void notify() {
    notifyListeners();
  }

  Future firstLoad() async {}

  Future<bool> signUp() async {
    return await comnApiPost(
      url: '/users/signup',
      body: {
        'email': 'apptest',
        'password': '1234',
        'phone_no': user.phoneNo,
      },
      prov: this,
      onGet: (result) async {
        // comnLog(result);
        if (result.isSuccessful()) {
          return true;
        } else {
          return false;
        }
      },
    );
  }

  Future<String> emailSend({
    required String email,
  }) async {
    return await comnApiPost(
      url: '/users/mailsend',
      body: {
        'email': email,
      },
      prov: this,
      onGet: (result) async {
        return result['responseStatusCode'].toString();
      },
    );
  }

  Future<String> emailVerify({
    required String email,
    required String code,
  }) async {
    return await comnApiPost(
      url: '/users/mailverify',
      body: {
        'email': email,
        'user_code': code,
      },
      prov: this,
      onGet: (result) async {
        return result['responseStatusCode'].toString();
      },
    );
  }

  Future<bool> emailSubmit({
    required bool isValidEmail,
  }) async {
    bool returnValue = false;
    String condition;
    String title;
    String content;
    if (isValidEmail) {
      condition = await emailSend(email: user.email);
      if (condition == '200') {
        // isSent = true;
        returnValue = true;
        title = '성공';
        content = '메일함을 확인해주세요.';
      } else if (condition == '404') {
        returnValue = false;
        title = '중복';
        content = '이미 존재하는 이메일입니다.';
      } else {
        returnValue = false;
        title = '오류';
        content = '잠시 후 다시 시도해주세요.';
      }
      await comnShowDialog(
          dialog: ComnDialog(
        type: ComnDialogType.single,
        title: title,
        contents: content,
        onRightTap: () {
          Navigator.pop(globalContext);
        },
      ));
    }
    return returnValue;
  }

  Future<bool> codeSubmit() async {
    bool returnValue = false;
    String condition;
    condition = await emailVerify(
      email: user.email,
      code: model.codeTextController.text,
    );

    if (condition == '200') {
      returnValue = true;
      await comnShowDialog(
          dialog: ComnDialog(
        type: ComnDialogType.single,
        title: '성공',
        contents: '인증 성공',
        onRightTap: () {
          Navigator.pop(globalContext);
        },
      ));
    } else {
      returnValue = false;
      await comnShowDialog(
          dialog: ComnDialog(
        type: ComnDialogType.single,
        title: '오류',
        contents: '인증 코드를 다시 확인해보세요.',
        onRightTap: () {
          Navigator.pop(globalContext);
        },
      ));
    }

    return returnValue;
  }
}
