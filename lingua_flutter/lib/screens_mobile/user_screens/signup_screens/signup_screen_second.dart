// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:lingua/models/user_model.dart';
import 'package:lingua/util/api/api_user.dart';
import '../../../widgets/user_widgets/from_field.dart';
import '../login_screen.dart';

class StringConstants {
  static const String password = '비밀번호';
  static const String passwordCheck = '비밀번호 확인';
  static const String phone_no = '휴대폰 번호';
}

class SignUpScreenSecond extends StatefulWidget {
  const SignUpScreenSecond({super.key});

  @override
  State<SignUpScreenSecond> createState() => _SignUpScreenSecondState();
}

class _SignUpScreenSecondState extends State<SignUpScreenSecond> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();
  bool isVerifeid = false;
  bool isSent = false;
  bool isFormComplete = false;
  bool isLoading = false;

  String _password = '';
  String _passwordCheck = '';
  String _phoneNo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: 35,
            color: Colors.grey.shade600,
          ),
        ),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                buildFormField(
                  isObscure: true,
                  onSaved: (value) => _password = value!,
                  labelText: StringConstants.password,
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
                buildFormField(
                  isObscure: true,
                  onSaved: (value) => _passwordCheck = value!,
                  labelText: StringConstants.passwordCheck,
                  validator: (value) {
                    if (value != UserModel.password) {
                      return '비밀번호가 동일하지 않습니다.';
                    }
                    return null;
                  },
                ),
                buildFormField(
                  isObscure: false,
                  onSaved: (value) => _phoneNo = value!,
                  labelText: StringConstants.phone_no,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '전화번호를 입력해주세요.';
                    }
                    if (!_isValidPhoneNumber(value)) {
                      return '올바른 전화번호 형식을 입력해주세요.';
                    }
                    UserModel.phoneNo = value;
                    return null;
                  },
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                        } else {
                          return;
                        }
                        ApiUser.signUp();
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var begin = const Offset(0.0, 0.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;
                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                            pageBuilder:
                                (context, anmation, secondaryAnimation) =>
                                    const LoginScreen(),
                          ),
                        );
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('성공'),
                              content: const Text('회원가입 성공, 로그인하여 진행하세요.'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('확인'),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // 알림 창을 닫습니다.
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                        ),
                        child: const Center(
                            child: Text(
                          '완료',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Neo',
                          ),
                        )),
                      ),
                    ),
                  ),
                ),
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

  bool _isValidPhoneNumber(String phoneNo) {
    final RegExp regex =
        RegExp(r"^(01[016789])-?([0-9]{3,4})-?([0-9]{4})$"); // 휴대전화
    // final RegExp regex2 =
    //     RegExp(r"^(0[2-9]{1,2})-?([0-9]{3,4})-?([0-9]{4})$"); // 일반 전화

    // return regex.hasMatch(phoneNo) || regex2.hasMatch(phoneNo);
    return regex.hasMatch(phoneNo);
  }
}
