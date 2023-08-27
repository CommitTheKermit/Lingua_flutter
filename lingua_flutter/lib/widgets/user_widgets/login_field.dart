
import 'package:flutter/material.dart';

class LoginField extends StatelessWidget {
  final String hintText;
  const LoginField({
    super.key,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: hintText,
        ),
      ),
    );
  }
}
