import 'package:flutter/material.dart';
import 'package:lingua/screens_mobile/user_screens/Id_Pw_screens/pw_change_screen.dart';
import 'package:lingua/util/api/api_user.dart';
import 'package:lingua/util/etc/validators.dart';
import 'package:lingua/widgets/commons/common_appbar.dart';
import 'package:lingua/widgets/read_widgets/fields/labeled_form_field.dart';

import '../../../widgets/read_widgets/dialog/consent_dialog.dart';
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
    return Padding(
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
                labeledFormField(
                  onSaved: (value) => _email = value!,
                  argText: '전화번호',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '';
                    }
                    if (!Validators.isValidPhoneNumber(value)) {
                      return '';
                    }
                    _phoneNo = value;
                    return null;
                  },
                ),
                labeledFormField(
                  onSaved: (value) => _email = value!,
                  argText: '이메일',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '';
                    }
                    if (!Validators.isValidEmail(value)) {
                      return '';
                    }
                    _email = value.toLowerCase();
                    return null;
                  },
                ),
                buildFormButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: _submit,
                  argText: '찾기',
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
}
