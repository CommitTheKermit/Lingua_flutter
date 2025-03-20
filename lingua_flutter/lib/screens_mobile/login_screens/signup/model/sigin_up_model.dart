import 'package:flutter/material.dart';

class SignUpModel {
  final formKey = GlobalKey<FormState>();
  final TextEditingController codeTextController = TextEditingController();
  bool isVerifeid = false;
  bool isSent = false;
  bool isFormComplete = false;
  bool isLoading = false;
  bool isEmailSent = false;

  String email = '';
  final String password = '';
  String passwordCheck = '';
  String phoneNo = '';

  final domains = [
    'naver.com',
    'gmail.com',
    'daum.net',
    'nate.com',
    'hanmail.net',
    '직접입력',
  ];
  String selectedDomain = 'naver.com';

  bool isShowTextField = false;
  bool isShowEmail = false;
  bool isValidEmail = false;
}
