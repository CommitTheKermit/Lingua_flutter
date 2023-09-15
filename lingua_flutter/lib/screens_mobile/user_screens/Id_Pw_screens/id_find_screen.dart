// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:lingua/screens_mobile/user_screens/Id_Pw_screens/pw_find_screen.dart';

import '../../../services/api/api_user.dart';
import '../../../widgets/user_widgets/consent_dialog.dart';
import '../../../widgets/user_widgets/form_button.dart';
import '../../../widgets/user_widgets/from_field.dart';

class IdFindScreen extends StatefulWidget {
  const IdFindScreen({super.key});

  @override
  State<IdFindScreen> createState() => _IdFindScreenState();
}

class _IdFindScreenState extends State<IdFindScreen> {
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
                '아이디 찾기',
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
                  buildFormButton(
                    context: context,
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: _submit,
                    argText: '찾기',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  buildFormButton(
                    context: context,
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
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
                                  const PwFindScreen(),
                        ),
                      );
                    },
                    argText: '비밀번호 찾기',
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
    String result;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      result = await ApiUser.idFind(_phoneNo);

      if (result.contains('@') && mounted) {
        isVerifeid = true;
        consentDialog(
          title: '성공',
          content: '$_phoneNo를 가진 이메일은 $result입니다',
          context: context,
        );
      } else if (!result.contains('@') && mounted) {
        consentDialog(
          title: '실패',
          content: '존재하지 않는 전화번호입니다.',
          context: context,
        );
      } else {
        consentDialog(
          title: '오류',
          content: '잠시 후 다시 시도해주세요.',
          context: context,
        );
      }
    }
    setState(() {
      isLoading = false;
    });
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
