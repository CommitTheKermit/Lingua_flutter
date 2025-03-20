// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/screens_mobile/login/view/login.dart';
import 'package:lingua/screens_mobile/login/view_model/login_prov.dart';
import 'package:lingua/utils/api/api_user.dart';
import 'package:lingua/utils/uitl.dart';
import 'package:lingua/widgets/commons/common_appbar.dart';
import 'package:lingua/widgets/commons/comn_dialog.dart';
import 'package:lingua/widgets/read_widgets/fields/labeled_form_field.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PwChangeScreen extends StatefulWidget {
  const PwChangeScreen({
    super.key,
    required this.email,
    required this.phoneNo,
  });

  final String email;
  final String phoneNo;

  @override
  State<PwChangeScreen> createState() => _PwChangeScreenState();
}

class _PwChangeScreenState extends State<PwChangeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();

  bool isVerifeid = false;
  bool isSent = false;
  bool isFormComplete = false;
  bool isLoading = false;

  String _password = '';
  String _passwordCheck = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(context: context, argText: ''),
      body: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.only(
              left: 20,
              top: 20,
            ),
            child: Text(
              '새로운 비밀번호를 설정해주세요.',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 50,
                ),
                LabeledFormField(
                  onSaved: (value) => _password = value!,
                  argText: '비밀번호',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '비밀번호를 입력해주세요.';
                    }
                    if (value.length < 10) {
                      return '비밀번호는 10자 이상이어야 합니다.';
                    }
                    // 기타 다른 검증 로직들 (예: _isValidEmail 함수)이 있다면, 그 아래에 추가
                    user.password = value;
                    return null;
                  },
                ),
                LabeledFormField(
                  onSaved: (value) => _passwordCheck = value!,
                  argText: '비밀번호 확인',
                  validator: (value) {
                    if (value != user.password) {
                      return '비밀번호가 동일하지 않습니다.';
                    }
                    return null;
                  },
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          user.password = _password;
                        } else {
                          return;
                        }

                        pwChange(
                          phoneNo: widget.phoneNo,
                          email: widget.email,
                        );

                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              var begin = const Offset(0.0, 0.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;
                              var tween =
                                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                            pageBuilder: (context, anmation, secondaryAnimation) =>
                                ChangeNotifierProvider(
                                    create: (context) => LoginProv(), child: const LoginScreen()),
                          ),
                        );

                        await comnShowDialog(
                            dialog: const ComnDialog(
                          type: ComnDialogType.single,
                          title: '성공',
                          contents: '비밀번호 변경 완료, 변경된 비밀번호로 로그인 해주세요.',
                        ));
                      },
                      child: Container(
                        width: 90.w,
                        height: 60,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF1E4A75),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                        child: Center(
                            child: Text(
                          '비밀번호 재설정',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFFF8F9FA),
                            fontSize: 2.25.h,
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 3.h,
                )
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
}
