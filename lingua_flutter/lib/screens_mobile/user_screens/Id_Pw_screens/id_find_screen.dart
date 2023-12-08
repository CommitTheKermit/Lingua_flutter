// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:lingua/util/api/api_user.dart';
import 'package:lingua/util/etc/validators.dart';
import 'package:lingua/widgets/read_widgets/fields/labeled_form_field.dart';

import '../../../widgets/read_widgets/dialog/consent_dialog.dart';
import '../../../widgets/user_widgets/form_button.dart';

class IdFindScreen extends StatefulWidget {
  const IdFindScreen({super.key});

  @override
  State<IdFindScreen> createState() => _IdFindScreenState();
}

class _IdFindScreenState extends State<IdFindScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isPhoneNumberValid = false;
  bool isVerifeid = false;
  bool isSent = false;
  bool isFormComplete = false;
  bool isLoading = false;

  String _email = '';
  String _phoneNo = '';

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Center(
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  labeledFormField(
                    argText: '휴대폰 번호',
                    hintText: '‘-’를 제외한 숫자만 입력해 주세요.',
                    onSaved: (value) => _email = value!,
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
                    onChanged: (p0) {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isPhoneNumberValid = true;
                        });
                      } else {
                        setState(() {
                          isPhoneNumberValid = false;
                        });
                      }
                    },
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: buildFormButton(
                        backgroundColor: isPhoneNumberValid
                            ? const Color(0xFF1E4A75)
                            : const Color(0xFFDEE2E6),
                        onPressed: _submit,
                        argText: '찾기',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
}
