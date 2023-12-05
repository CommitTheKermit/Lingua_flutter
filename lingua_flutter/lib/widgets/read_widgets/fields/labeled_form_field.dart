import 'package:flutter/material.dart';
import 'package:lingua/main.dart';

Widget labeledFormField({
  required FormFieldSetter<String> onSaved,
  required String argText,
  required FormFieldValidator<String> validator,
  String hintText = '',
  Function(String)? onChanged,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: AppLingua.height * 0.015),
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
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Container(
          width: AppLingua.width * 0.9,
          height: AppLingua.height * 0.06,
          decoration: ShapeDecoration(
            color: const Color(0xFFF8F9FA),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFDEE2E6)),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppLingua.height * 0.011),
            child: Center(
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                    errorStyle: TextStyle(
                      height: 0.1,
                      fontSize: AppLingua.height * 0.01,
                    )),
                onSaved: onSaved,
                validator: validator,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
