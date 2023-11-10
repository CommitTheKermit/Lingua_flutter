import 'package:flutter/material.dart';
import 'package:lingua/models/user_model.dart';
import 'package:lingua/screens_mobile/read_screen.dart';
import 'package:lingua/screens_mobile/user_screens/Id_Pw_screens/pw_find_screen.dart';
import 'package:lingua/screens_mobile/user_screens/signup_screens/signup_screen_first.dart';
import 'package:lingua/util/api/api_user.dart';
import 'package:lingua/util/change_screen.dart';

import 'package:lingua/util/exit_confirm.dart';
import 'package:lingua/util/shared_preferences/preference_manager.dart';
import 'package:lingua/widgets/user_widgets/consent_dialog.dart';

import '../../widgets/user_widgets/form_button.dart';
import '../../widgets/user_widgets/from_field.dart';
import '../../widgets/user_widgets/next_screen_button.dart';
import 'Id_Pw_screens/id_find_screen.dart';

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
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 250,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        'LINGUA',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Color(LoginScreen.orangeColor),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      buildFormField(
                        controller: controller,
                        prefixImage: Image.asset('assets/user.png'),
                        isObscure: false,
                        onSaved: (value) => _email = value!,
                        labelText: '이메일',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '이메일을 입력해주세요.';
                          }
                          if (!_isValidEmail(value)) {
                            return '올바른 이메일 형식을 입력해주세요.';
                          }
                          UserModel.email = value.toLowerCase();
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      buildFormField(
                        prefixImage: Image.asset('assets/key.png'),
                        isObscure: true,
                        onSaved: (value) => _password = value!,
                        labelText: '비밀번호',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '비밀번호를 입력해주세요.';
                          }
                          if (value.length < 10) {
                            return '비밀번호는 10자 이상이어야 합니다.';
                          }
                          // 기타 다른 검증 로직들 (예: _isValidEmail 함수)이 있다면, 그 아래에 추가
                          UserModel.password = value;
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Row(
                          children: [
                            Checkbox(
                              value: isEmailRecord,
                              onChanged: (value) {
                                setState(() {
                                  isEmailRecord = value!;
                                });
                              },
                            ),
                            const Text('이메일 기억하기'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      buildFormButton(
                        context: context,
                        backgroundColor: Theme.of(context).primaryColor,
                        argText: '로그인',
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            print('$_email $_password');
                          } else {
                            return;
                          }
                          bool condition = await ApiUser.login();

                          if (condition && mounted) {
                            if (isEmailRecord && recordedEmail!.isEmpty) {
                              PreferenceManager.saveBoolValue(
                                  'isEmailRecord', isEmailRecord);
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
                              content: '아이디와 비밀번호를 다시 확인해보세요',
                              context: context,
                            );
                          }
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            NextScreenButton(
                              buttonColor: Colors.white,
                              textColor: Colors.black,
                              inButtonText: '회원가입',
                              nextScreen: SignUpScreenFirst(),
                              navigatorAction: 1,
                              buttonWidth: null,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  NextScreenButton(
                                    buttonColor: Colors.white,
                                    textColor: Colors.black,
                                    inButtonText: '아이디 찾기',
                                    nextScreen: IdFindScreen(),
                                    navigatorAction: 1,
                                    buttonWidth: 140,
                                  ),
                                  NextScreenButton(
                                    buttonColor: Colors.white,
                                    textColor: Colors.black,
                                    inButtonText: '비밀번호 찾기',
                                    nextScreen: PwFindScreen(),
                                    navigatorAction: 1,
                                    buttonWidth: 140,
                                  )
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
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  bool _isValidEmail(String email) {
    final RegExp regex =
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
    return regex.hasMatch(email);
  }
}
