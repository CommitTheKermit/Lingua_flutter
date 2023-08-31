import 'package:flutter/material.dart';
import 'package:lingua/models/user_model.dart';
import 'package:lingua/screens_mobile/user_screens/signup_screens/signup_screen_second.dart';

import '../../../services/api/api_user.dart';
import '../../../widgets/user_widgets/consent_dialog.dart';
import '../../../widgets/user_widgets/next_join_button.dart';

class StringConstants {
  static const String email = '이메일';
  static const String emailCode = '인증번호';
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
  bool isSent = false;
  bool isFormComplete = false;
  bool isLoading = false;

  String _email = '';

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
                _buildFormField(
                  onSaved: (value) => _email = value!,
                  labelText: StringConstants.email,
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
                buildFormButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: _emailSubmit,
                  argText: '이메일 인증',
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 26.0, vertical: 10),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: StringConstants.emailCode,
                      border: OutlineInputBorder(),
                    ),
                    controller: textEditingController,
                  ),
                ),
                buildFormButton(
                  backgroundColor:
                      isVerifeid ? Theme.of(context).primaryColor : Colors.grey,
                  onPressed: isVerifeid ? _codeSubmit : () {},
                  argText: '인증번호 확인',
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: NextJoinButton(
                      isSent: isSent,
                      inButtonText: '다음',
                      nextScreen: const SignUpScreenSecond(),
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

  void _emailSubmit() async {
    setState(() {
      isLoading = true;
    });
    bool condition;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      UserModel.email = _email;
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

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    } else {
      return null;
    }

    bool condition;
    condition = await ApiUser.emailVerify(
      UserModel.email,
      textEditingController.text,
    );

    if (condition && mounted) {
      isSent = true;
      consentDialog(
        title: '성공',
        content: '인증 성공',
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

  bool _isValidEmail(String email) {
    final RegExp regex =
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
    return regex.hasMatch(email);
  }

  Widget _buildFormField({
    required FormFieldSetter<String> onSaved,
    required String labelText,
    required FormFieldValidator<String> validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 10),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }

  Widget buildFormButton({
    required Color backgroundColor,
    required void Function() onPressed,
    required String argText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 2),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
        ),
        onPressed: onPressed,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Center(
            child: Text(
              argText,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'Neo',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
