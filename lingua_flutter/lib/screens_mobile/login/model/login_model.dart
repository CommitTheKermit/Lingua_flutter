import 'package:flutter/material.dart';

class LoginModel{
  Future? futureLoad;

  final TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String email = '';

  String password = '';

  late bool isAutoLogin;

  String? recordedEmail = '';
}