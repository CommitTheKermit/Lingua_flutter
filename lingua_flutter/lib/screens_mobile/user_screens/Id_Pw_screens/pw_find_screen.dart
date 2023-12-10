import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/screens_mobile/user_screens/Id_Pw_screens/pw_change_screen.dart';
import 'package:lingua/util/api/api_user.dart';
import 'package:lingua/util/etc/validators.dart';
import 'package:lingua/widgets/read_widgets/fields/labeled_form_field.dart';

import '../../../widgets/read_widgets/dialog/consent_dialog.dart';
import '../../../widgets/user_widgets/form_button.dart';

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
  bool _isShowTextField = false;
  bool isShowEmail = false;
  bool isValidEmail = false;

  bool isPhoneNumberValid = false;

  String _selectedDomain = '';

  String _email = '';
  String _phoneNo = '';

  final _domains = [
    'naver.com',
    'gmail.com',
    'daum.net',
    'nate.com',
    'hanmail.net',
    '직접입력',
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _selectedDomain = _domains[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              labeledFormField(
                onSaved: (value) => _email = value!,
                argText: '전화번호',
                validator: (value) {
                  if (value!.isEmpty) {
                    return null;
                  }
                  if (!Validators.isValidPhoneNumber(value)) {
                    return null;
                  }
                  _phoneNo = value;
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
              // labeledFormField(
              //   onSaved: (value) => _email = value!,
              //   argText: '이메일',
              //   validator: (value) {
              //     if (value!.isEmpty) {
              //       return '';
              //     }
              //     if (!Validators.isValidEmail(value)) {
              //       return '';
              //     }
              //     _email = value.toLowerCase();
              //     return null;
              //   },
              // ),

              emailField(
                argText: '이메일',
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: buildFormButton(
                    backgroundColor: isPhoneNumberValid && isValidEmail
                        ? const Color(0xFF1E4A75)
                        : const Color(0xFFDEE2E6),
                    onPressed:
                        isPhoneNumberValid && isValidEmail ? _submit : () {},
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

  Widget emailField({
    required String argText,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: AppLingua.height * 0.015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: AppLingua.height * 0.01,
            ),
            child: Text(
              argText,
              style: TextStyle(
                color: const Color(0xFF868E96),
                fontSize: AppLingua.height * 0.02,
                fontFamily: 'Noto Sans KR',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            width: AppLingua.width * 0.9,
            height: AppLingua.height * 0.06,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: !_isShowTextField
                ? Row(
                    children: [
                      Container(
                        width: AppLingua.width * 0.4,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF8F9FA),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFFDEE2E6)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: TextFormField(
                          onSaved: (value) =>
                              _email = '${value!}@$_selectedDomain',
                          onChanged: (p0) {
                            if (Validators.isValidEmail(
                              '$p0@$_selectedDomain',
                            )) {
                              setState(() {
                                isValidEmail = true;
                                _email = '$p0@$_selectedDomain';
                              });
                            } else {
                              setState(() {
                                isValidEmail = false;
                              });
                            }
                          },
                          onTap: () {
                            setState(() {
                              isShowEmail = true;
                            });
                          },
                          style: TextStyle(
                            color: const Color(0xFF868E96),
                            fontSize: AppLingua.height * 0.02,
                          ),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: AppLingua.width * 0.1,
                        child: Center(
                          child: Text(
                            '@',
                            style: TextStyle(
                              color: const Color(0xFF868E96),
                              fontSize: AppLingua.height * 0.02,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: AppLingua.width * 0.4,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF8F9FA),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFFDEE2E6)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: DropdownButton(
                          underline: const SizedBox.shrink(),
                          isExpanded: true,
                          icon: Image.asset(
                            'assets/images/dropbox_down.png',
                            height: AppLingua.height * 0.02,
                          ),
                          value: _selectedDomain,
                          items: _domains
                              .map((e) => DropdownMenuItem(
                                    value: e, // 선택 시 onChanged 를 통해 반환할 value
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: AppLingua.width * 0.02,
                                      ),
                                      child: Text(
                                        e,
                                        style: TextStyle(
                                          color: const Color(0xFF868E96),
                                          fontSize: AppLingua.height * 0.02,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            // items 의 DropdownMenuItem 의 value 반환
                            setState(() {
                              _selectedDomain = value!;
                              if (_selectedDomain == '직접입력') {
                                _isShowTextField = true;
                                _email = '';
                              }
                            });
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
                              width: AppLingua.width * 0.9,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFF8F9FA),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1, color: Color(0xFFDEE2E6)),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: TextFormField(
                                onSaved: (value) => _email = value!,
                                onChanged: (p0) {
                                  if (Validators.isValidEmail(p0)) {
                                    setState(() {
                                      isValidEmail = true;
                                      _email = '$p0@$_selectedDomain';
                                    });
                                  } else {
                                    setState(() {
                                      isValidEmail = false;
                                    });
                                  }
                                },
                                style: TextStyle(
                                  color: const Color(0xFF868E96),
                                  fontSize: AppLingua.height * 0.02,
                                ),
                                decoration: InputDecoration(
                                  fillColor: Colors.transparent,
                                  hintText: '이메일',
                                  hintStyle: TextStyle(
                                    color: const Color(0xFF868E96),
                                    fontSize: AppLingua.height * 0.02,
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
                        left: AppLingua.width * 0.5,
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: AppLingua.width * 0.333,
                            child: DropdownButton(
                              underline: const SizedBox.shrink(),
                              isExpanded: true,
                              icon: Image.asset(
                                'assets/images/dropbox_down.png',
                                height: AppLingua.height * 0.02,
                              ),
                              value: !_isShowTextField ? _selectedDomain : null,
                              items: _domains
                                  .map((e) => DropdownMenuItem(
                                        value:
                                            e, // 선택 시 onChanged 를 통해 반환할 value
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: AppLingua.width * 0.02,
                                          ),
                                          child: Text(
                                            e,
                                            style: TextStyle(
                                              color: const Color(0xFF868E96),
                                              fontSize: AppLingua.height * 0.02,
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                // items 의 DropdownMenuItem 의 value 반환
                                setState(() {
                                  _selectedDomain = value!;
                                  if (_selectedDomain != '직접입력') {
                                    _isShowTextField = false;
                                  }
                                });
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
