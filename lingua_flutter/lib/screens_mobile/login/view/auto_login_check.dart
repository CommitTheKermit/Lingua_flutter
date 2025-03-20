import 'package:flutter/material.dart';
import 'package:lingua/screens_mobile/login/view_model/login_prov.dart';
import 'package:lingua/widgets/commons/common.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AutoLoginCheckBox extends StatefulWidget {
  const AutoLoginCheckBox({Key? key}) : super(key: key);

  @override
  State<AutoLoginCheckBox> createState() => _AutoLoginCheckBoxState();
}

class _AutoLoginCheckBoxState extends State<AutoLoginCheckBox> {
  @override
  Widget build(BuildContext context) {
    LoginProv loginProv = Provider.of<LoginProv>(context);
    return Row(
      children: [
        Checkbox(
          side: const BorderSide(width: 1, color: Color(0xFF43698F)),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFF43698F)),
            borderRadius: BorderRadius.circular(4),
          ),
          activeColor: const Color(0xFF44698F),
          checkColor: Colors.white,
          value: loginProv.model.isAutoLogin,
          onChanged: (value) {
            loginProv.model.isAutoLogin = value!;
            setState(() {});
          },
        ),
        comnText(
          '자동 로그인',
          colorFont: const Color(0xFF868E96),
          fontSize: 1.75.h,
        ),
      ],
    );
  }
}
