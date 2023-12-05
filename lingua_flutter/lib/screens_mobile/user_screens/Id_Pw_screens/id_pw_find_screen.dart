// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lingua/main.dart';
import 'package:lingua/screens_mobile/user_screens/Id_Pw_screens/id_find_screen.dart';
import 'package:lingua/screens_mobile/user_screens/Id_Pw_screens/pw_find_screen.dart';

import 'package:lingua/widgets/commons/common_appbar.dart';

class IDPWFindScreen extends StatefulWidget {
  const IDPWFindScreen({super.key});

  @override
  State<IDPWFindScreen> createState() => _IDPWFindScreenState();
}

class _IDPWFindScreenState extends State<IDPWFindScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: 0,
    animationDuration: const Duration(milliseconds: 100),
  );

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(context: context, argText: '아이디/비밀번호찾기'),
      body: Scaffold(
        backgroundColor: const Color(0xFFF4F4F4),
        appBar: GFAppBar(
          titleSpacing: 0.0,
          automaticallyImplyLeading: false,
          elevation: 0.5,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: GFSegmentTabs(
            height: AppLingua.height * 0.0675,
            width: AppLingua.width,
            tabController: tabController,
            tabBarColor: GFColors.WHITE,
            labelColor: GFColors.WHITE,
            unselectedLabelColor: GFColors.DARK,
            indicator: const BoxDecoration(
              color: Color(0xFF44698F),
            ),
            border: Border.all(color: GFColors.DARK, width: 0.3),
            length: 3,
            tabs: [
              SizedBox(
                height: 40,
                child: Center(
                  child: Text(
                    '아이디 찾기',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppLingua.height * 0.0225,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: Center(
                  child: Text(
                    '비밀번호 찾기',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppLingua.height * 0.0225,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: GFTabBarView(
          controller: tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: const <Widget>[
            IdFindScreen(),
            PwFindScreen(),
          ],
        ),
      ),
    );
  }
}
