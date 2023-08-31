import 'package:flutter/material.dart';
import 'package:lingua/models/user_model.dart';

import '../../../services/api/api_user.dart';
import '../../../widgets/user_widgets/from_field.dart';
import '../login_screen.dart';

class StringConstants {
  static const String password = '비밀번호';
  static const String passwordCheck = '비밀번호 확인';
}

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
                        
                        ApiUser.pwChange(
                          phoneNo: widget.phoneNo,
                          email: widget.email,
                        );

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
                              content: const Text('비밀번호 변경 완료, 로그인하여 진행하세요.'),
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

}
