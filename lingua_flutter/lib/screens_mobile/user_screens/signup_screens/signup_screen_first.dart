import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/models/user_model.dart';
import 'package:lingua/screens_mobile/user_screens/login_screen.dart';
import 'package:lingua/util/api/api_user.dart';
import 'package:lingua/util/etc/change_screen.dart';
import 'package:lingua/util/etc/validators.dart';
import 'package:lingua/widgets/commons/common_appbar.dart';
import 'package:lingua/widgets/read_widgets/fields/labeled_form_field.dart';

import '../../../widgets/read_widgets/dialog/consent_dialog.dart';
import '../../../widgets/user_widgets/next_join_button.dart';

class SignUpScreenFirst extends StatefulWidget {
  const SignUpScreenFirst({super.key});

  @override
  State<SignUpScreenFirst> createState() => _SignUpScreenFirstState();
}

class _SignUpScreenFirstState extends State<SignUpScreenFirst> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();
  bool isVerifeid = false;
  bool isSent = false;
  bool isFormComplete = false;
  bool isLoading = false;
  bool isEmailSent = false;

  String _email = '';
  final String _password = '';
  String _passwordCheck = '';
  String _phoneNo = '';

  final _domains = [
    'naver.com',
    'gmail.com',
    'daum.net',
    'nate.com',
    'hanmail.net',
    '직접입력',
  ];
  String _selectedDomain = '';

  bool _isShowTextField = false;
  bool isShowEmail = false;
  bool isValidEmail = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedDomain = _domains[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: commonAppBar(context: context, argText: '회원가입'),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: AppLingua.height * 0.015),
                emailField(
                  argText: '이메일 인증',
                ),
                emailCode(),
                labeledFormField(
                  onSaved: (value) => UserModel.password = value!,
                  argText: '비밀번호',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '비밀번호를 입력해주세요.';
                    }
                    if (value.length < 10) {
                      return '비밀번호는 10자 이상이어야 합니다.';
                    }
                    UserModel.password = value;
                    return null;
                  },
                  onChanged: (p0) {
                    _formKey.currentState!.validate();
                  },
                ),
                labeledFormField(
                  onSaved: (value) => _passwordCheck = value!,
                  argText: '비밀번호 확인',
                  validator: (value) {
                    if (value != UserModel.password) {
                      return '비밀번호가 동일하지 않습니다.';
                    }
                    return null;
                  },
                  onChanged: (p0) {
                    _formKey.currentState!.validate();
                  },
                ),
                labeledFormField(
                  onSaved: (value) => _phoneNo = value!,
                  argText: '휴대폰 번호',
                  validator: (value) {
                    if (!Validators.isValidPhoneNumber(value!)) {
                      return '잘못된 전화번호 형식입니다.';
                    }
                    UserModel.phoneNo = value;
                    return null;
                  },
                  onChanged: (p0) {
                    _formKey.currentState!.validate();
                  },
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: buildFormButton(
                      backgroundColor: isVerifeid
                          ? const Color(0xFF1E4A75)
                          : const Color(0xFFDEE2E6),
                      onPressed: isVerifeid
                          ? () async {
                              bool result = await ApiUser.signUp();
                              if (result) {
                                await consentDialog(
                                    title: '성공',
                                    content: '가입을 환영합니다!',
                                    context: context);
                                changeScreen(
                                    context: context,
                                    nextScreen: const LoginScreen(),
                                    isReplace: true);
                              }
                            }
                          : () {},
                      argText: '가입',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Expanded(
                //   child: Align(
                //     alignment: Alignment.bottomCenter,
                //     child: NextJoinButton(
                //       isSent: isSent,
                //       inButtonText: '다음',
                //       nextScreen: const LoginScreen(),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  void _emailSubmit() async {
    setState(() {
      isLoading = true;
    });
    bool condition;
    if (isValidEmail) {
      condition = await ApiUser.emailSend(UserModel.email);
      if (condition && mounted) {
        isVerifeid = true;
        consentDialog(
          title: '성공',
          content: '메일함을 확인해주세요.',
          context: context,
        );
      } else {
        consentDialog(
          title: '오류',
          content: '잠시 후 다시 시도해주세요.',
          context: context,
        );
        // 여기에서 사용자에게 알림을 보냅니다.
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void _codeSubmit() async {
    setState(() {
      isLoading = true;
    });

    String condition;
    condition = await ApiUser.emailVerify(
      UserModel.email,
      textEditingController.text,
    );

    if (condition == '200' && mounted) {
      isSent = true;
      consentDialog(
        title: '성공',
        content: '인증 성공',
        context: context,
      );
    } else if (condition == '404') {
      consentDialog(
        title: '중복',
        content: '이미 존재하는 이메일입니다.',
        context: context,
      );
    } else {
      consentDialog(
        title: '오류',
        content: '인증 코드를 다시 확인해보세요.',
        context: context,
      );
      // 여기에서 사용자에게 알림을 보냅니다.
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget buildFormButton({
    required Color backgroundColor,
    required void Function() onPressed,
    required String argText,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        width: AppLingua.width * 0.9,
        height: AppLingua.height * 0.0625,
        child: Center(
          child: Text(
            argText,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Neo',
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget emailCode() {
    return Padding(
      padding: EdgeInsets.only(
          top: AppLingua.height * 0.01, bottom: AppLingua.height * 0.015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppLingua.width * 0.9,
            height: AppLingua.height * 0.06,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Row(
              children: [
                Container(
                  width: AppLingua.width * 0.53,
                  height: AppLingua.height * 0.06,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF8F9FA),
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFFDEE2E6)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppLingua.height * 0.011),
                    child: TextFormField(
                      controller: textEditingController,
                      style: TextStyle(
                        color: const Color(0xFF868E96),
                        fontSize: AppLingua.height * 0.02,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: AppLingua.width * 0.02,
                ),
                !isEmailSent
                    ? GestureDetector(
                        onTap: () {
                          _emailSubmit();
                          isEmailSent = true;
                        },
                        child: Container(
                          width: AppLingua.width * 0.35,
                          height: AppLingua.height * 0.06,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF43698F),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Color(0xFFDEE2E6)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '인증메일발송',
                              style: TextStyle(
                                  color: const Color(0xFFF8F9FA),
                                  fontSize: AppLingua.height * 0.022,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _codeSubmit();
                        },
                        child: Container(
                          width: AppLingua.width * 0.35,
                          height: AppLingua.height * 0.06,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF43698F),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          child: Center(
                            child: Text(
                              '인증확인',
                              style: TextStyle(
                                  color: const Color(0xFFF8F9FA),
                                  fontSize: AppLingua.height * 0.022,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget emailField({
    required String argText,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: AppLingua.height * 0.015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: AppLingua.height * 0.01,
            ),
            child: Text(
              argText,
              style: TextStyle(
                color: const Color(0xFF868E96),
                fontSize: AppLingua.height * 0.02,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            width: AppLingua.width * 0.9,
            height: AppLingua.height * 0.06,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: !_isShowTextField
                ? Row(
                    children: [
                      Container(
                        width: AppLingua.width * 0.4,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF8F9FA),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFFDEE2E6)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              isValidEmail = false;
                              return '이메일을 입력해주세요.';
                            }
                            if (!Validators.isValidEmail(
                                '$value@$_selectedDomain')) {
                              isValidEmail = false;
                              return '잘못된 이메일 형식입니다.';
                            }
                            isValidEmail = true;
                            UserModel.email = '$value@$_selectedDomain';
                            return null;
                          },
                          onChanged: (p0) {
                            _formKey.currentState!.validate();
                          },
                          style: TextStyle(
                            color: const Color(0xFF868E96),
                            fontSize: AppLingua.height * 0.02,
                          ),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            errorStyle: TextStyle(fontSize: 0),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: AppLingua.width * 0.1,
                        child: Center(
                          child: Text(
                            '@',
                            style: TextStyle(
                              color: const Color(0xFF868E96),
                              fontSize: AppLingua.height * 0.02,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: AppLingua.width * 0.4,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF8F9FA),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFFDEE2E6)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: DropdownButton(
                          underline: const SizedBox.shrink(),
                          isExpanded: true,
                          icon: Image.asset(
                            'assets/images/dropbox_down.png',
                            height: AppLingua.height * 0.02,
                          ),
                          value: _selectedDomain,
                          items: _domains
                              .map((e) => DropdownMenuItem(
                                    value: e, // 선택 시 onChanged 를 통해 반환할 value
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: AppLingua.width * 0.02,
                                      ),
                                      child: Text(
                                        e,
                                        style: TextStyle(
                                          color: const Color(0xFF868E96),
                                          fontSize: AppLingua.height * 0.02,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            // items 의 DropdownMenuItem 의 value 반환

                            setState(() {
                              _selectedDomain = value!;
                              _formKey.currentState!.validate();
                              if (_selectedDomain == '직접입력') {
                                _isShowTextField = true;
                                _email = '';
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      Positioned.fill(
                        child: Row(
                          children: [
                            Container(
                              width: AppLingua.width * 0.9,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFF8F9FA),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1, color: Color(0xFFDEE2E6)),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: TextFormField(
                                onSaved: (value) => _email = value!,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    isValidEmail = false;
                                    return '이메일을 입력해주세요.';
                                  }
                                  if (!Validators.isValidEmail(value)) {
                                    isValidEmail = false;
                                    return '잘못된 이메일 형식입니다.';
                                  }
                                  isValidEmail = true;
                                  UserModel.email = value;
                                  return null;
                                },
                                onChanged: (p0) {
                                  _formKey.currentState!.validate();
                                },
                                style: TextStyle(
                                  color: const Color(0xFF868E96),
                                  fontSize: AppLingua.height * 0.02,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  fillColor: Colors.transparent,
                                  hintText: '이메일',
                                  hintStyle: TextStyle(
                                    color: const Color(0xFF868E96),
                                    fontSize: AppLingua.height * 0.02,
                                    fontWeight: FontWeight.w400,
                                    height: 0.5,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned.fill(
                        left: AppLingua.width * 0.5,
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: AppLingua.width * 0.333,
                            child: DropdownButton(
                              underline: const SizedBox.shrink(),
                              isExpanded: true,
                              icon: Image.asset(
                                'assets/images/dropbox_down.png',
                                height: AppLingua.height * 0.02,
                              ),
                              value: !_isShowTextField ? _selectedDomain : null,
                              items: _domains
                                  .map((e) => DropdownMenuItem(
                                        value:
                                            e, // 선택 시 onChanged 를 통해 반환할 value
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: AppLingua.width * 0.02,
                                          ),
                                          child: Text(
                                            e,
                                            style: TextStyle(
                                              color: const Color(0xFF868E96),
                                              fontSize: AppLingua.height * 0.02,
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                // items 의 DropdownMenuItem 의 value 반환
                                setState(() {
                                  _selectedDomain = value!;
                                  _formKey.currentState!.validate();
                                  if (_selectedDomain != '직접입력') {
                                    _isShowTextField = false;
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
