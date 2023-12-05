import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/models/user_model.dart';
import 'package:lingua/widgets/commons/common_text.dart';

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
        width: AppLingua.width * 0.7,
        child: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // const SizedBox(
              //   height: 50,
              //   child: DrawerHeader(
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //     ),
              //     child: Text('Drawer Header'),
              //   ),
              // ),
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Container(
                width: AppLingua.width * 0.7,
                height: AppLingua.height * 0.06,
                decoration: const BoxDecoration(color: Color(0xFF43698F)),
              ),
              SizedBox(
                width: AppLingua.height * 0.04,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppLingua.width * 0.05,
                    vertical: AppLingua.height * 0.035),
                child: Container(
                  width: AppLingua.width * 0.66,
                  height: AppLingua.height * 0.15,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFFDEE2E6)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.all(AppLingua.height * 0.01),
                          child: commonText(
                            labelText: '로그아웃',
                            fontColor: const Color(0xFFADB5BD),
                            fontSize: AppLingua.width * 0.035,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: AppLingua.height * 0.0175,
                      ),
                      commonText(
                          labelText: UserModel.email,
                          fontSize: AppLingua.height * 0.02),
                      SizedBox(
                        height: AppLingua.height * 0.015,
                      ),
                      Container(
                        width: AppLingua.width * 0.55,
                        height: AppLingua.height * 0.0375,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF43698F),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: Center(
                          child: commonText(
                            labelText: UserModel.email,
                            fontSize: AppLingua.height * 0.0175,
                            fontColor: const Color(0xFFF8F9FA),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
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
