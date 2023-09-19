import 'package:flutter/material.dart';

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
        width: MediaQuery.of(context).size.width / 2 - 50,
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
              const SizedBox(
                height: 30,
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
