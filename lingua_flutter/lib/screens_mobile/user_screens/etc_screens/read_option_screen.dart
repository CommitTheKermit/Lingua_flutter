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
  double optFontSize = 20;
  double optFontHeight = 1;
  String optFontFamily = 'Neo';
  Color optFontColor = Colors.black;
  Color optBackgroundColor = Colors.white;

  String _selectedFont = '';
  final _fonts = [
    'Neo',
    'Gangwon',
    'Gmarket',
    'Hakgyo',
    'Jaemin',
    'Pretendard',
  ];

  final backgroundColors = [
    0xFFFFFFFF,
    0xFFE9E5DA,
    0xFF4A4A4A,
    0xFF2A2A2A,
    0xFFE4D0BE,
    0xFFC3B083,
    0xFFCFCED3,
    0xFFD1DCEA,
  ];
  final fontColors = [
    0x000000,
    0x4A4A4A,
    0xFFFFFF,
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    setState(() {
      _selectedFont = _fonts[0];
    });
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
      body: GFTabBarView(
        controller: tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  commonDivider(context),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: optBackgroundColor,
                    ),
                    child: Center(
                      child: Text(
                        '적용 예시입니다.\n각 칸별 설정이 가능합니다.',
                        style: TextStyle(
                          fontSize: optFontSize,
                          height: optFontHeight,
                          fontFamily: optFontFamily,
                          color: optFontColor,
                        ),
                      ),
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
                        argText: optFontSize.toString(),
                        upButtonTap: () {
                          setState(() {
                            optFontSize += 0.5;
                          });
                        },
                        downButtonTap: () {
                          setState(() {
                            optFontSize -= 0.5;
                          });
                        },
                        upButtonVaild: optFontSize < 30 ? true : false,
                        downButtonValid: optFontSize >= 10 ? true : false,
                      ),
                      optionUpDown(
                        labelText: '줄 간격',
                        argText: optFontHeight.toStringAsFixed(1),
                        upButtonTap: () {
                          setState(() {
                            optFontHeight += 0.1;
                          });
                        },
                        downButtonTap: () {
                          setState(() {
                            optFontHeight -= 0.1;
                          });
                        },
                        upButtonVaild: optFontHeight <= 2.5 ? true : false,
                        downButtonValid: optFontHeight > 1 ? true : false,
                      ),
                    ],
                  ),
                  commonDivider(context),
                  optionSingleContainer(
                    context: context,
                    containerHeight: 200,
                    lines: [
                      optionFontSelect(labelText: '폰트 선택', argText: 'asd'),
                      optionFontColorSelect(labelText: '글자색'),
                      optionBackgroundSelect(labelText: '배경색'),
                    ],
                  ),
                  commonDivider(context),
                  Expanded(
                      child: optionSingleContainer(
                          context: context, containerHeight: 10)),
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
        ],
      ),
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
    required Function() upButtonTap,
    required Function() downButtonTap,
    required String argText,
    required bool upButtonVaild,
    required bool downButtonValid,
  }) {
    return Padding(
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
                Padding(
                  padding: const EdgeInsets.only(
                    right: 15,
                  ),
                  child: Text(
                    argText,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                InkWell(
                  onTap: upButtonVaild ? upButtonTap : () {},
                  child: Container(
                    height: 45,
                    width: 80,
                    decoration: BoxDecoration(
                      color: upButtonVaild
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade400,
                    ),
                    child: Transform.rotate(
                      angle: pi / 2,
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: downButtonValid ? downButtonTap : () {},
                  child: Container(
                    height: 45,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                      color:
                          downButtonValid ? Colors.white : Colors.grey.shade400,
                    ),
                    child: Transform.rotate(
                      angle: pi + pi / 2,
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget optionFontSelect({
    required String labelText,
    required String argText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
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
                SizedBox(
                  width: 200,
                  child: DropdownButton(
                    underline: const SizedBox.shrink(),
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 33,
                    ),
                    value: optFontFamily,
                    items: _fonts
                        .map((e) => DropdownMenuItem(
                              value: e, // 선택 시 onChanged 를 통해 반환할 value
                              child: Text(
                                e,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: _fonts[_fonts.indexOf(e)],
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      // items 의 DropdownMenuItem 의 value 반환
                      setState(() {
                        optFontFamily = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget optionFontColorSelect({
    required String labelText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Center(
              child: commonText(
                labelText: labelText,
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 12,
                right: 15,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: backgroundColors
                      .map(
                        (value) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                optFontColor = Color(value);
                              });
                            },
                            child: Container(
                              width: 50,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.5,
                                ),
                                color: Color(
                                  value,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget optionBackgroundSelect({
    required String labelText,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
          child: Center(
            child: commonText(
              labelText: labelText,
              fontSize: 18,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 12,
              right: 15,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: backgroundColors
                    .map(
                      (value) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              optBackgroundColor = Color(value);
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                              ),
                              color: Color(
                                value,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList()
                    .reversed
                    .toList(),
              ),
            ),
          ),
        )
      ],
    );
  }
}
