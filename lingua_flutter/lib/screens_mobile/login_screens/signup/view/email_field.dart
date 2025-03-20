import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/screens_mobile/login_screens/signup/view_model/sign_up_prov.dart';
import 'package:lingua/utils/etc/validators.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EmailField extends StatelessWidget {
  const EmailField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SignUpProv signUpProv = Provider.of<SignUpProv>(context);
    return Padding(
      padding: EdgeInsets.only(top: 1.5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: 1.h,
            ),
            child: Text(
              '이메일 인증',
              style: TextStyle(
                color: const Color(0xFF868E96),
                fontSize: 2.h,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            width: 90.w,
            height: 6.h,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: !signUpProv.model.isShowTextField
                ? Row(
                    children: [
                      Container(
                        width: 40.w,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF8F9FA),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 1, color: Color(0xFFDEE2E6)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              signUpProv.model.isValidEmail = false;
                              return '이메일을 입력해주세요.';
                            }
                            if (!Validators.isValidEmail(
                                '$value@${signUpProv.model.selectedDomain}')) {
                              signUpProv.model.isValidEmail = false;
                              return '잘못된 이메일 형식입니다.';
                            }
                            signUpProv.model.isValidEmail = true;
                            user.email = '$value@${signUpProv.model.selectedDomain}';
                            return null;
                          },
                          onChanged: (p0) {
                            signUpProv.model.formKey.currentState!.validate();
                          },
                          style: TextStyle(
                            color: const Color(0xFF868E96),
                            fontSize: 2.h,
                          ),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            errorStyle: TextStyle(fontSize: 0),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                        child: Center(
                          child: Text(
                            '@',
                            style: TextStyle(
                              color: const Color(0xFF868E96),
                              fontSize: 2.h,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 40.w,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF8F9FA),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 1, color: Color(0xFFDEE2E6)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: DropdownButton(
                          dropdownColor: Colors.white,
                          underline: const SizedBox.shrink(),
                          isExpanded: true,
                          icon: Image.asset(
                            'assets/images/dropbox_down.png',
                            height: 2.h,
                          ),
                          value: signUpProv.model.selectedDomain,
                          items: signUpProv.model.domains
                              .map((e) => DropdownMenuItem(
                                    value: e, // 선택 시 onChanged 를 통해 반환할 value
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 2.w,
                                      ),
                                      child: Text(
                                        e,
                                        style: TextStyle(
                                          color: const Color(0xFF868E96),
                                          fontSize: 2.h,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            // items 의 DropdownMenuItem 의 value 반환

                            signUpProv.model.selectedDomain = value!;
                            signUpProv.model.formKey.currentState!.validate();
                            if (signUpProv.model.selectedDomain == '직접입력') {
                              signUpProv.model.isShowTextField = true;
                              signUpProv.model.email = '';
                            }
                            signUpProv.notify();
                          },
                        ),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      Positioned.fill(
                        child: Row(
                          children: [
                            Container(
                              width: 90.w,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFF8F9FA),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(width: 1, color: Color(0xFFDEE2E6)),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: TextFormField(
                                onSaved: (value) => signUpProv.model.email = value!,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    signUpProv.model.isValidEmail = false;
                                    return '이메일을 입력해주세요.';
                                  }
                                  if (!Validators.isValidEmail(value)) {
                                    signUpProv.model.isValidEmail = false;
                                    return '잘못된 이메일 형식입니다.';
                                  }
                                  signUpProv.model.isValidEmail = true;
                                  user.email = value;
                                  return null;
                                },
                                onChanged: (p0) {
                                  signUpProv.model.formKey.currentState!.validate();
                                },
                                style: TextStyle(
                                  color: const Color(0xFF868E96),
                                  fontSize: 2.h,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  fillColor: Colors.transparent,
                                  hintText: '이메일',
                                  hintStyle: TextStyle(
                                    color: const Color(0xFF868E96),
                                    fontSize: 2.h,
                                    fontWeight: FontWeight.w400,
                                    height: 0.5,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned.fill(
                        left: 50.w,
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 33.3.w,
                            child: DropdownButton(
                              underline: const SizedBox.shrink(),
                              isExpanded: true,
                              icon: Image.asset(
                                'assets/images/dropbox_down.png',
                                height: 2.h,
                              ),
                              value: !signUpProv.model.isShowTextField
                                  ? signUpProv.model.selectedDomain
                                  : null,
                              items: signUpProv.model.domains
                                  .map((e) => DropdownMenuItem(
                                        value: e, // 선택 시 onChanged 를 통해 반환할 value
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: 2.w,
                                          ),
                                          child: Text(
                                            e,
                                            style: TextStyle(
                                              color: const Color(0xFF868E96),
                                              fontSize: 2.h,
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                // items 의 DropdownMenuItem 의 value 반환

                                signUpProv.model.selectedDomain = value!;
                                signUpProv.model.formKey.currentState!.validate();
                                if (signUpProv.model.selectedDomain != '직접입력') {
                                  signUpProv.model.isShowTextField = false;
                                }
                                signUpProv.notify();
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
