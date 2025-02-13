// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:lingua/utils/api/api_user.dart';
import 'package:lingua/utils/etc/validators.dart';
import 'package:lingua/utils/uitl.dart';
import 'package:lingua/widgets/commons/comn_dialog.dart';
import 'package:lingua/widgets/read_widgets/fields/labeled_form_field.dart';

import '../../../../../../widgets/user_widgets/form_button.dart';

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

  final String _email = '';
  String phoneNo = '';

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
                    onSaved: (value) => phoneNo = value!,
                    validator: (value) {
                      phoneNo = value!;
                      return null;
                    },
                    onChanged: (p0) {
                      if (Validators.isValidPhoneNumber(p0)) {
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
                      child: CompleteFormButton(
                        backgroundColor:
                            isPhoneNumberValid ? const Color(0xFF1E4A75) : const Color(0xFFDEE2E6),
                        onPressed: isPhoneNumberValid ? submit : () {},
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

  void submit() async {
    setState(() {
      isLoading = true;
    });
    String result;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      result = await idFind(phoneNo);

      if (result.contains('@') && mounted) {
        isVerifeid = true;
        await comnShowDialog(
            dialog: ComnDialog(
          type: ComnDialogType.single,
          title: '성공',
          contents: '$phoneNo를 가진 이메일은 $result입니다',
        ));
      } else if (!result.contains('@') && mounted) {
        await comnShowDialog(
            dialog: const ComnDialog(
          type: ComnDialogType.single,
          title: '실패',
          contents: '존재하지 않는 전화번호입니다.',
        ));
      } else {
        await comnShowDialog(
            dialog: const ComnDialog(
          type: ComnDialogType.single,
          title: '오류',
          contents: '잠시 후 다시 시도해주세요.',
        ));
      }
    }
    isLoading = false;
    setState(() {});
  }
}
