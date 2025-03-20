import 'package:flutter/material.dart';
import 'package:lingua/screens_mobile/login_screens/signup/view/code_verify_button.dart';
import 'package:lingua/screens_mobile/login_screens/signup/view_model/sign_up_prov.dart';
import 'package:lingua/widgets/commons/show_progress.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EmailCode extends StatelessWidget {
  const EmailCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SignUpProv signUpProv = Provider.of<SignUpProv>(context);
    return Padding(
      padding: EdgeInsets.only(
        top: 1.h,
        bottom: 1.5.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 90.w,
            height: 6.h,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Row(
              children: [
                Container(
                  width: 53.w,
                  height: 6.h,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF8F9FA),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: Color(0xFFDEE2E6)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.1.h),
                    child: TextFormField(
                      controller: signUpProv.model.codeTextController,
                      style: TextStyle(
                        color: const Color(0xFF868E96),
                        fontSize: 2.h,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 2.w,
                ),
                CodeVerifyButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
