import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/screens_mobile/login/view/login.dart';
import 'package:lingua/screens_mobile/login/view_model/login_prov.dart';
import 'package:lingua/utils/etc/change_screen.dart';
import 'package:lingua/widgets/commons/common.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReadDrawer extends StatelessWidget {
  const ReadDrawer({
    super.key,
    required this.listTiles,
  });

  final List<ListTile> listTiles;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: 70.w,
        child: Drawer(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Container(
                width: 70.w,
                height: 6.h,
                decoration: const BoxDecoration(color: Color(0xFF43698F)),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 2.w),
                      child: Image.asset(
                        "assets/images/launcher_icon_small.png",
                        width: 10.w,
                      ),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      'Lingua',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFF8F9FA),
                        fontSize: 2.h,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 4.20,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 4.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.5.h),
                child: Container(
                  width: 66.w,
                  height: 12.5.h,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: Color(0xFFDEE2E6)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.all(1.h),
                          child: GestureDetector(
                            onTap: () async {
                              await changeScreen(nextScreen: ChangeNotifierProvider(create: (context) => LoginProv(), child: LoginScreen()), isReplace: true);
                            },
                            child: comnText(
                              '로그아웃',
                              colorFont: const Color(0xFFADB5BD),
                              fontSize: 2.h,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1.75.h,
                      ),
                      comnText(user.email, fontSize: 2.h),
                      SizedBox(
                        height: 1.5.h,
                      ),
                    ],
                  ),
                ),
              ),

              for (int i = 0; i < listTiles.length; i++) listTiles[i]

              // ListTile(
              //   title: const Text('항목 1'),
              //   onTap: () {
              //     // 항목을 탭하면 수행할 작업
              //     Navigator.pop(context); // Drawer를 닫습니다.
              //   },
              // ),
              // 다른 리스트 항목들을 추가할 수 있습니다.
            ],
          ),
        ),
      ),
    );
  }
}
