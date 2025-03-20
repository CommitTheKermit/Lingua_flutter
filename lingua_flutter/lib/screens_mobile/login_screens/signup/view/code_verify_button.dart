import 'package:flutter/material.dart';
import 'package:lingua/screens_mobile/login_screens/signup/view_model/sign_up_prov.dart';
import 'package:lingua/widgets/commons/show_progress.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CodeVerifyButton extends StatefulWidget {
  const CodeVerifyButton({Key? key}) : super(key: key);

  @override
  State<CodeVerifyButton> createState() => _CodeVerifyButtonState();
}

class _CodeVerifyButtonState extends State<CodeVerifyButton> {
  @override
  Widget build(BuildContext context) {
    SignUpProv signUpProv = Provider.of<SignUpProv>(context);
    return !signUpProv.model.isVerifeid
        ? !signUpProv.model.isEmailSent
            ? GestureDetector(
                onTap: () async {
                  signUpProv.model.isEmailSent = await showFutureProgress(
                      futureFn: signUpProv.emailSubmit(
                    isValidEmail: signUpProv.model.isValidEmail,
                  ));
                  signUpProv.notify();
                },
                child: Container(
                  width: 35.w,
                  height: 6.h,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF43698F),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: Color(0xFFDEE2E6)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '인증 메일 발송',
                      style: TextStyle(
                        color: const Color(0xFFF8F9FA),
                        fontSize: 2.h,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
            : GestureDetector(
                onTap: () async {
                  signUpProv.model.isVerifeid =
                      await showFutureProgress(futureFn: signUpProv.codeSubmit());
                  signUpProv.notify();
                },
                child: Container(
                  width: 35.w,
                  height: 6.h,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF43698F),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Center(
                    child: Text(
                      '인증 확인',
                      style: TextStyle(
                          color: const Color(0xFFF8F9FA),
                          fontSize: 2.2.h,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              )
        : Container(
            width: 35.w,
            height: 6.h,
            decoration: ShapeDecoration(
              color: const Color(0xffaaaaaa),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
            child: Center(
              child: Text(
                '인증 완료',
                style: TextStyle(
                    color: const Color(0xFFF8F9FA), fontSize: 2.2.h, fontWeight: FontWeight.w600),
              ),
            ),
          );
  }
}
