import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/screens_mobile/home/view/home.dart';
import 'package:lingua/screens_mobile/login/view/auto_login_check.dart';
import 'package:lingua/screens_mobile/login/view_model/login_prov.dart';
import 'package:lingua/screens_mobile/login_screens/accounts/view/find/id_pw_find_screen.dart';
import 'package:lingua/screens_mobile/login_screens/signup/view/sign_up.dart';
import 'package:lingua/screens_mobile/login_screens/signup/view_model/sign_up_prov.dart';
import 'package:lingua/utils/etc/change_screen.dart';

import 'package:lingua/utils/etc/exit_confirm.dart';
import 'package:lingua/utils/shared_preferences/preferences.dart';
import 'package:lingua/utils/uitl.dart';
import 'package:lingua/widgets/commons/common.dart';
import 'package:lingua/widgets/commons/common_widget.dart';
import 'package:lingua/widgets/commons/comn_dialog.dart';
import 'package:lingua/widgets/commons/show_progress.dart';
import 'package:lingua/widgets/user_widgets/form_button.dart';
import 'package:lingua/screens_mobile/login/view/form_field.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    LoginProv loginProv = Provider.of<LoginProv>(context, listen: false);
    loginProv.model.isAutoLogin = getPrefBool('isAutoLogin') ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginProv loginProv = Provider.of<LoginProv>(context);
    loginProv.model.futureLoad ??= loginProv.firstLoad();
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
        future: loginProv.model.futureLoad,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return comnLoading();
          } else {
            if (snapshot.data == 'autoLogin') {
              return const HomeScreen();
            } else {
              return PopScope(
                onPopInvokedWithResult: (value, result) async {
                  await exitConfirm(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 16.5.h,
                  ),
                  child: Form(
                    key: loginProv.model.formKey,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/logo_color.png',
                          width: 30.w,
                          height: 15.h,
                        ),
                        SizedBox(
                          height: 7.5.h,
                        ),
                        LoginFormField(
                          onSubmitted: (value) {},
                          textInputAction: TextInputAction.next,
                          controller: loginProv.model.controller,
                          isObscure: false,
                          onSaved: (value) => loginProv.model.email = value!,
                          labelText: '이메일',
                          validator: (value) {
                            // if (value!.isEmpty) {
                            //   return '이메일을 입력해주세요.';
                            // }
                            // if (!_isValidEmail(value)) {
                            //   return '올바른 이메일 형식을 입력해주세요.';
                            // }
                            if (value != null && value.isNotEmpty) {
                              user.email = value.toLowerCase();
                              return null;
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        LoginFormField(
                          onSubmitted: (value) async {
                            if (loginProv.model.formKey.currentState!.validate()) {
                              loginProv.model.formKey.currentState!.save();
                              comnLog('${loginProv.model.email} ${loginProv.model.password}');
                            } else {
                              return;
                            }
                            bool result = await showFutureProgress(
                              futureFn: loginProv.loginCall(),
                            );
                            if (result) {
                              await changeScreen(
                                nextScreen: const HomeScreen(),
                                isReplace: true,
                              );
                            }
                          },
                          textInputAction: TextInputAction.done,
                          isObscure: true,
                          onSaved: (value) => loginProv.model.password = value!,
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
                              user.password = value;
                              return null;
                            }
                            return null;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const AutoLoginCheckBox(),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await changeScreen(
                                        nextScreen: const IDPWFindScreen(), isReplace: false);
                                  },
                                  child: comnText(
                                    '아이디',
                                    colorFont: const Color(0xFF868E96),
                                    fontSize: 1.75.h,
                                  ),
                                ),
                                SizedBox(
                                  height: 1.375.h,
                                  child: VerticalDivider(
                                    thickness: 2,
                                    width: 4.w,
                                    color: const Color(0xFF868E96),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await changeScreen(
                                        nextScreen: const IDPWFindScreen(), isReplace: false);
                                  },
                                  child: comnText(
                                    '비밀번호 찾기',
                                    colorFont: const Color(0xFF868E96),
                                    fontSize: 1.75.h,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 5.h),
                        CompleteFormButton(
                          backgroundColor: const Color(0xFF1E4A75),
                          argText: '로그인',
                          onPressed: () async {
                            if (loginProv.model.formKey.currentState!.validate()) {
                              loginProv.model.formKey.currentState!.save();
                              comnLog('${loginProv.model.email} ${loginProv.model.password}');
                            } else {
                              return;
                            }
                            bool result = await showFutureProgress(
                              futureFn: loginProv.loginCall(),
                            );
                            if (result) {
                              await changeScreen(
                                nextScreen: const HomeScreen(),
                                isReplace: true,
                              );
                            }
                          },
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        comnText('아직 링구아 회원이 아니신가요?',
                            colorFont: const Color(0xFF868E96), fontSize: 1.75.h),
                        SizedBox(
                          height: 1.375.h,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await changeScreen(
                              nextScreen: ChangeNotifierProvider(
                                create: (_) => SignUpProv(),
                                child: const SignUpScreen(),
                              ),
                              isReplace: false,
                            );
                          },
                          child: comnText('회원가입',
                              colorFont: const Color(0xFF1E4A75), fontSize: 1.75.h),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
