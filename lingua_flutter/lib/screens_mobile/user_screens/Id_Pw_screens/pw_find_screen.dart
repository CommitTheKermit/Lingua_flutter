import 'package:flutter/material.dart';
import 'package:lingua/screens_mobile/user_screens/Id_Pw_screens/pw_change_screen.dart';
import 'package:lingua/util/api/api_user.dart';

import '../../../widgets/user_widgets/consent_dialog.dart';
import '../../../widgets/user_widgets/form_button.dart';
import '../../../widgets/user_widgets/from_field.dart';

class PwFindScreen extends StatefulWidget {
  const PwFindScreen({super.key});

  @override
  State<PwFindScreen> createState() => _PwFindScreenState();
}

class _PwFindScreenState extends State<PwFindScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController textEditingController = TextEditingController();

  bool isVerifeid = false;

  bool isSent = false;

  bool isFormComplete = false;

  bool isLoading = false;

  String _email = '';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.only(
                left: 20,
                top: 20,
              ),
              child: Text(
                '비밀번호 찾기',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
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
                    isObscure: false,
                    onSaved: (value) => _email = value!,
                    labelText: '전화번호',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '전화번호를 입력해주세요.';
                      }
                      if (!_isValidPhoneNumber(value)) {
                        return '올바른 전화번호를 입력해주세요.';
                      }
                      _phoneNo = value;
                      return null;
                    },
                  ),
                  buildFormField(
                    isObscure: false,
                    onSaved: (value) => _email = value!,
                    labelText: '이메일',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '이메일을 입력해주세요.';
                      }
                      if (!_isValidEmail(value)) {
                        return '올바른 이메일을 입력해주세요.';
                      }
                      _email = value.toLowerCase();
                      return null;
                    },
                  ),
                  buildFormButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: _submit,
                    argText: '찾기',
                    context: context,
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
      ),
    );
  }

  void _submit() async {
    setState(() {
      isLoading = true;
    });
    bool condition;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      condition = await ApiUser.pwFind(_phoneNo, _email);

      if (condition && mounted) {
        isVerifeid = true;
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
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
                PwChangeScreen(
              email: _email,
              phoneNo: _phoneNo,
            ),
          ),
        );
      } else {
        consentDialog(
          title: '실패',
          content: '전화번호와 이메일을 다시 확인해보세요.',
          context: context,
        );
      }
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

  bool _isValidPhoneNumber(String phoneNo) {
    final RegExp regex =
        RegExp(r"^(01[016789])-?([0-9]{3,4})-?([0-9]{4})$"); // 휴대전화
    // final RegExp regex2 =
    //     RegExp(r"^(0[2-9]{1,2})-?([0-9]{3,4})-?([0-9]{4})$"); // 일반 전화

    // return regex.hasMatch(phoneNo) || regex2.hasMatch(phoneNo);
    return regex.hasMatch(phoneNo);
  }
}
