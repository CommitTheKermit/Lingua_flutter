import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/screens_mobile/login/view/login.dart';
import 'package:lingua/screens_mobile/login/view_model/login_prov.dart';
import 'package:lingua/screens_mobile/login_screens/signup/view/email_code.dart';
import 'package:lingua/screens_mobile/login_screens/signup/view/email_field.dart';
import 'package:lingua/screens_mobile/login_screens/signup/view/form_button.dart';
import 'package:lingua/screens_mobile/login_screens/signup/view_model/sign_up_prov.dart';
import 'package:lingua/utils/etc/change_screen.dart';
import 'package:lingua/utils/etc/validators.dart';
import 'package:lingua/utils/uitl.dart';
import 'package:lingua/widgets/commons/common_appbar.dart';
import 'package:lingua/widgets/commons/comn_dialog.dart';
import 'package:lingua/widgets/read_widgets/fields/labeled_form_field.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    SignUpProv signUpProv = Provider.of<SignUpProv>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: commonAppBar(context: context, argText: '회원가입'),
      body: Form(
        key: signUpProv.model.formKey,
        child: Column(
          children: [
            SizedBox(height: 1.5.h),
            const EmailField(),
            const EmailCode(),
            LabeledFormField(
              onSaved: (value) => user.password = value!,
              argText: '비밀번호',
              validator: (value) {
                if (value!.isEmpty) {
                  return '비밀번호를 입력해주세요.';
                }
                if (value.length < 10) {
                  return '비밀번호는 10자 이상이어야 합니다.';
                }
                user.password = value;
                return null;
              },
              onChanged: (p0) {
                signUpProv.model.formKey.currentState!.validate();
              },
            ),
            LabeledFormField(
              onSaved: (value) => signUpProv.model.passwordCheck = value!,
              argText: '비밀번호 확인',
              validator: (value) {
                if (value != user.password) {
                  return '비밀번호가 동일하지 않습니다.';
                }
                return null;
              },
              onChanged: (p0) {
                signUpProv.model.formKey.currentState!.validate();
              },
            ),
            LabeledFormField(
              onSaved: (value) => signUpProv.model.phoneNo = value!,
              argText: '휴대폰 번호',
              validator: (value) {
                if (!Validators.isValidPhoneNumber(value!)) {
                  return '잘못된 전화번호 형식입니다.';
                }
                user.phoneNo = value;
                return null;
              },
              onChanged: (p0) {
                signUpProv.model.formKey.currentState!.validate();
              },
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FormButton(
                  backgroundColor: signUpProv.model.isVerifeid
                      ? const Color(0xFF1E4A75)
                      : const Color(0xFFDEE2E6),
                  onPressed: signUpProv.model.isVerifeid
                      ? () async {
                          bool result = await signUpProv.signUp();
                          if (result) {
                            await comnShowDialog(
                                dialog: ComnDialog(
                              type: ComnDialogType.single,
                              title: '성공',
                              contents: '가입을 환영합니다!',
                              onRightTap: () {
                                Navigator.pop(context);
                              },
                            ));
                            await changeScreen(
                                nextScreen: ChangeNotifierProvider(
                                  create: (context) => LoginProv(),
                                  child: const LoginScreen(),
                                ),
                                isReplace: true);
                          }
                        }
                      : () {},
                  argText: '가입',
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // Expanded(
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: NextJoinButton(
            //       isSent: isSent,
            //       inButtonText: '다음',
            //       nextScreen: const LoginScreen(),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
