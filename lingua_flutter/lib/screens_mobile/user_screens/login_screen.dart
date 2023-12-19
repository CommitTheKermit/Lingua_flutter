import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/models/user_model.dart';
import 'package:lingua/screens_mobile/main_screens/read_screen.dart';

import 'package:lingua/screens_mobile/user_screens/Id_Pw_screens/id_pw_find_screen.dart';
import 'package:lingua/screens_mobile/user_screens/Id_Pw_screens/pw_find_screen.dart';
import 'package:lingua/screens_mobile/user_screens/signup_screens/signup_screen_first.dart';
import 'package:lingua/util/api/api_user.dart';
import 'package:lingua/util/etc/change_screen.dart';

import 'package:lingua/util/etc/exit_confirm.dart';
import 'package:lingua/util/shared_preferences/preference_manager.dart';
import 'package:lingua/widgets/commons/common_text.dart';
import 'package:lingua/widgets/read_widgets/dialog/consent_dialog.dart';

import '../../widgets/user_widgets/form_button.dart';
import '../../widgets/user_widgets/from_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const int orangeColor = 0xFFF49349;
  static const int whiteColor = 0x00000000;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';

  String _password = '';

  late bool isEmailRecord;
  late Future<String> futureOption;
  final TextEditingController controller = TextEditingController();
  String? recordedEmail = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureOption = initAsync();
  }

  Future<String> initAsync() async {
    try {
      final temp = await PreferenceManager.getBoolValue('isEmailRecord');

      if (temp == null) {
        isEmailRecord = false;
        return 'done';
      } else {
        recordedEmail = await PreferenceManager.getValue('email');
        if (recordedEmail == null) {
          isEmailRecord = false;
          return 'error';
        } else {
          controller.text = recordedEmail!;
        }

        isEmailRecord = temp;
      }
    } catch (e) {
      return 'error';
    }

    return 'done';
  }

  @override
  Widget build(BuildContext context) {
    log("width ${AppLingua.width.toString()}");
    log("height ${AppLingua.height.toString()}");
    return FutureBuilder(
      future: futureOption,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: WillPopScope(
              onWillPop: () async {
                return exitConfirm(context);
              },
              child: Padding(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: AppLingua.height * 0.165,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      commonText(
                        labelText: 'lingua',
                        fontSize: AppLingua.height * 0.0425,
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(
                        height: AppLingua.height * 0.1375,
                      ),
                      buildFormField(
                        controller: controller,
                        isObscure: false,
                        onSaved: (value) => _email = value!,
                        labelText: '이메일',
                        validator: (value) {
                          // if (value!.isEmpty) {
                          //   return '이메일을 입력해주세요.';
                          // }
                          // if (!_isValidEmail(value)) {
                          //   return '올바른 이메일 형식을 입력해주세요.';
                          // }
                          if (value != null && value.isNotEmpty) {
                            UserModel.email = value.toLowerCase();
                            return null;
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: AppLingua.height * 0.01,
                      ),
                      buildFormField(
                        isObscure: true,
                        onSaved: (value) => _password = value!,
                        labelText: '비밀번호',
                        validator: (value) {
                          // if (value!.isEmpty) {
                          //   return '비밀번호를 입력해주세요.';
                          // }
                          // if (value.length < 10) {
                          //   return '비밀번호는 10자 이상이어야 합니다.';
                          // }
                          // 기타 다른 검증 로직들 (예: _isValidEmail 함수)이 있다면, 그 아래에 추가
                          if (value != null && value.isNotEmpty) {
                            UserModel.password = value;
                            return null;
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                side: const BorderSide(
                                    width: 1, color: Color(0xFF43698F)),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1, color: Color(0xFF43698F)),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                activeColor: const Color(0xFF44698F),
                                checkColor: Colors.white,
                                value: isEmailRecord,
                                onChanged: (value) {
                                  setState(() {
                                    isEmailRecord = value!;
                                  });
                                },
                              ),
                              commonText(
                                labelText: '이메일 저장',
                                fontColor: const Color(0xFF868E96),
                                fontSize: AppLingua.height * 0.0175,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  changeScreen(
                                      context: context,
                                      nextScreen: const IDPWFindScreen(),
                                      isReplace: false);
                                },
                                child: commonText(
                                  labelText: '아이디',
                                  fontColor: const Color(0xFF868E96),
                                  fontSize: AppLingua.height * 0.0175,
                                ),
                              ),
                              SizedBox(
                                height: AppLingua.height * 0.01375,
                                child: VerticalDivider(
                                  thickness: 2,
                                  width: AppLingua.width * 0.04,
                                  color: const Color(0xFF868E96),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  changeScreen(
                                      context: context,
                                      nextScreen: const IDPWFindScreen(),
                                      isReplace: false);
                                },
                                child: commonText(
                                  labelText: '비밀번호 찾기',
                                  fontColor: const Color(0xFF868E96),
                                  fontSize: AppLingua.height * 0.0175,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: AppLingua.height * 0.05),
                      buildFormButton(
                        backgroundColor: const Color(0xFF1E4A75),
                        argText: '로그인',
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            print('$_email $_password');
                          } else {
                            return;
                          }
                          bool condition = await ApiUser.login();
                          // bool condition = false;
                          if (condition && mounted) {
                            if (isEmailRecord && recordedEmail!.isEmpty) {
                              PreferenceManager.saveBoolValue(
                                  'isEmailRecord', isEmailRecord);
                              PreferenceManager.saveValue('email', _email);
                            } else {
                              PreferenceManager.saveValue('email', _email);
                            }

                            changeScreen(
                              context: context,
                              nextScreen: const ReadScreen(),
                              isReplace: true,
                            );
                          } else {
                            changeScreen(
                              context: context,
                              nextScreen: const LoginScreen(),
                              isReplace: false,
                            );
                            consentDialog(
                              title: '실패',
                              content: '입력 정보를 다시 확인해보세요.',
                              context: context,
                            );
                          }
                        },
                      ),
                      SizedBox(
                        height: AppLingua.height * 0.06,
                      ),
                      commonText(
                          labelText: '아직 링구아 회원이 아니신가요?',
                          fontColor: const Color(0xFF868E96),
                          fontSize: AppLingua.height * 0.0175),
                      SizedBox(
                        height: AppLingua.height * 0.01375,
                      ),
                      GestureDetector(
                        onTap: () {
                          changeScreen(
                              context: context,
                              nextScreen: const SignUpScreenFirst(),
                              isReplace: false);
                        },
                        child: commonText(
                            labelText: '회원가입',
                            fontColor: const Color(0xFF1E4A75),
                            fontSize: AppLingua.height * 0.0175),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
