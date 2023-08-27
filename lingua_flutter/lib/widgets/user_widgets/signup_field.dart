// import 'package:flutter/material.dart';

// class SignUpField extends StatelessWidget {
//   const SignUpField({super.key, required this.name});

//   final String name;

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: '이름',
//                   border: OutlineInputBorder(),
//                 ),
//                 onSaved: (value) => name = value!,
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return '이름을 입력해주세요.';
//                   }
//                   return null;
//                 },
//               ),
//   }
// }