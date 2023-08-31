import 'package:flutter/material.dart';

class LoginField extends StatelessWidget {
  final String hintText;
  final bool isObscure;
  const LoginField({
    super.key,
    required this.hintText,
    required this.isObscure,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        obscureText: isObscure,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: hintText,
        ),
      ),
    );
  }
}
