import 'package:flutter/material.dart';
import 'package:lingua/screens_mobile/read_screen.dart';
import 'package:lingua/screens_mobile/signup_screens/signup_screen_first.dart';
import 'package:lingua/util/exit_confirm.dart';

import '../widgets/user_widgets/login_field.dart';
import '../widgets/user_widgets/next_screen_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static const int orangeColor = 0xFFF49349;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: () async {
          return exitConfirm(context);
        },
        child: const Padding(
          padding: EdgeInsets.only(
            left: 50,
            right: 50,
            top: 250,
          ),
          child: Column(
            children: [
              Text(
                'LINGUA',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Color(orangeColor),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              LoginField(
                hintText: "ID",
              ),
              SizedBox(
                height: 10,
              ),
              LoginField(
                hintText: "PW",
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NextScreenButton(
                      orangeColor: orangeColor,
                      inButtonText: 'Login',
                      nextScreen: ReadScreen(),
                      navigatorAction: 0,
                    ),
                    NextScreenButton(
                      orangeColor: orangeColor,
                      inButtonText: 'Signup',
                      nextScreen: SignUpScreenFirst(),
                      navigatorAction: 1,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
