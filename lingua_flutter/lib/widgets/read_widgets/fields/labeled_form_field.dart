import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LabeledFormField extends StatelessWidget {
  const LabeledFormField({
    Key? key,
    required this.onSaved,
    required this.argText,
    required this.validator,
    this.hintText = '',
    this.onChanged,
  }) : super(key: key);
  final FormFieldSetter<String> onSaved;
  final String argText;
  final FormFieldValidator<String> validator;
  final String hintText;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: 1.h,
            ),
            child: Text(
              argText,
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
            decoration: ShapeDecoration(
              color: const Color(0xFFF8F9FA),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFFDEE2E6)),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.1.h),
              child: Center(
                child: TextFormField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      hintText: hintText,
                      border: InputBorder.none,
                      errorStyle: TextStyle(
                        height: 0.1,
                        fontSize: 1.75.h,
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
}
