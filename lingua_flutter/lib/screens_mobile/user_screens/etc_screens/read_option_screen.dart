import 'dart:math';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lingua/widgets/commons/common_divider.dart';
import 'package:lingua/widgets/commons/common_text.dart';

class ReadOptionScreen extends StatefulWidget {
  const ReadOptionScreen({super.key});

  @override
  State<ReadOptionScreen> createState() => _ReadOptionScreenState();
}

class _ReadOptionScreenState extends State<ReadOptionScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  late double fontSize;
  late double fontHeight;
  late int whichFont;
  late Color fontColor;
  late Color backgroundColor;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: GFSegmentTabs(
          height: 40,
          width: 250,
          tabController: tabController,
          tabBarColor: GFColors.WHITE,
          labelColor: GFColors.WHITE,
          unselectedLabelColor: GFColors.DARK,
          indicator: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          border: Border.all(color: GFColors.DARK, width: 0.3),
          length: 3,
          tabs: const <Widget>[
            SizedBox(
              height: 40,
              child: Center(
                child: Text(
                  "상단",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: Center(
                child: Text(
                  "중단",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: Center(
                child: Text(
                  "하단",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      body: GFTabBarView(controller: tabController, children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                  ),
                ),
                // Divider(
                //   height: 10,
                //   color: Colors.grey.shade400,
                //   thickness: 0.5,
                // ),
                commonDivider(context),
                optionSingleContainer(
                  context: context,
                  containerHeight: 160,
                  lines: [
                    optionUpDown(
                      labelText: '글자 크기',
                      onTap: () {},
                    ),
                    optionUpDown(
                      labelText: '줄 간격',
                      onTap: () {},
                    ),
                  ],
                ),
                commonDivider(context),
                optionSingleContainer(
                  context: context,
                  containerHeight: 160,
                  lines: [
                    // optionSingleLine(
                    //   labelText: '폰트 선택',
                    //   onTap: () {},
                    // ),
                    // optionSingleLine(
                    //   labelText: '폰트 색상',
                    //   onTap: () {},
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Center(
          child: Text('Tab 2'),
        ),
        const Center(
          child: Text('Tab 3'),
        ),
      ]),
    );
  }

  Container optionSingleContainer({
    required BuildContext context,
    required double containerHeight,
    List<Widget>? lines,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: containerHeight,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        children: [
          if (lines != null) ...lines,
        ],
      ),
    );
  }

  Widget optionUpDown({
    required String labelText,
    required Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 17,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
                left: 15,
              ),
              child: Center(
                child: commonText(
                  labelText: labelText,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
                right: 15,
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      right: 15,
                    ),
                    child: Text(
                      '15',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    height: 45,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Transform.rotate(
                      angle: pi / 2,
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    height: 45,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                      color: Colors.white,
                    ),
                    child: Transform.rotate(
                      angle: pi + pi / 2,
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget optionSelect({
    required String labelText,
    required Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 17,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
                left: 15,
              ),
              child: Center(
                child: commonText(
                  labelText: labelText,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
                right: 15,
              ),
              child: Row(
                children: [
                  Container(
                    height: 45,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Transform.rotate(
                      angle: pi / 2,
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    height: 45,
                    width: 90,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                      color: Colors.white,
                    ),
                    child: Transform.rotate(
                      angle: pi + pi / 2,
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
