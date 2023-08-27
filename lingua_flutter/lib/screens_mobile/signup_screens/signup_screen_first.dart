import 'package:flutter/material.dart';
import 'package:lingua/models/user_model.dart';
import 'package:lingua/services/api/api_service.dart';

class StringConstants {
  static const String email = '이메일*';
  static const String emailCode = '인증번호*';
  static const String password = '비밀번호';
  static const String phone_no = '휴대폰 번호';
}

class SignUpScreenFirst extends StatefulWidget {
  const SignUpScreenFirst({super.key});

  @override
  State<SignUpScreenFirst> createState() => _SignUpScreenFirstState();
}

class _SignUpScreenFirstState extends State<SignUpScreenFirst> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();
  bool isVerifeid = false;
  bool isFormComplete = false;

  String _email = '';

  final String _emailCode = '';

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
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: StringConstants.email,
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _email = value!,
                validator: (value) {
                  if (value!.isEmpty) {
                    return '이메일을 입력해주세요.';
                  }
                  if (!_isValidEmail(value)) {
                    return '올바른 이메일 형식을 입력해주세요.';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: _submitForm,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: const Center(
                    child: Text(
                      '이메일 인증',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Neo',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: StringConstants.emailCode,
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                controller: textEditingController,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isVerifeid ? Theme.of(context).primaryColor : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    isFormComplete = true;
                  });
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: const Center(
                    child: Text(
                      '인증 확인',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Neo',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: const Center(
                        child: Text(
                      '다음',
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
    );
  }

  void _submitForm() async {
    bool condition;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      condition = await ApiService.emailSend(UserModel.email);
      if (condition && mounted) {
        isVerifeid = true;
        consentDialog(
          title: '성공',
          content: '메일함을 확인해주세요.',
        );
      } else {
        consentDialog(
          title: '오류',
          content: '이메일을 다시 확인해주세요.',
        );
        // 여기에서 사용자에게 알림을 보냅니다.
      }
    }
  }

  Future<dynamic> consentDialog(
      {required String title, required String content}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
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
  }

  bool _isValidEmail(String email) {
    final RegExp regex =
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
    return regex.hasMatch(email);
  }
}
