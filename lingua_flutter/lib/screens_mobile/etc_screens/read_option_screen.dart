import 'dart:math';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lingua/main.dart';
import 'package:lingua/models/read_option.dart';
import 'package:lingua/screens_mobile/read_screen.dart';
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
  ReadOption topOption = ReadScreen.topOption.clone();
  ReadOption midOption = ReadScreen.midOption.clone();
  ReadOption botOption = ReadScreen.botOption.clone();

  bool isChanged = false;
  bool isSaved = false;

  String _selectedFont = '';
  final _fonts = [
    'Noto Sans',
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
  // final fontColors = [
  //   0x000000,
  //   0x4A4A4A,
  //   0xFFFFFF,
  // ];

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
    return WillPopScope(
      onWillPop: () async {
        if (isChanged && !isSaved) {
          final result = await showDialog<String>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('확인 필요'),
                content: const Text('변경사항이 존재하지만, 저장하지 않았습니다.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('나가기'),
                    onPressed: () {
                      Navigator.of(context).pop('exit');
                    },
                  ),
                  TextButton(
                    child: const Text('저장'),
                    onPressed: () async {
                      await topOption.saveOption(key: 'topOption');
                      await midOption.saveOption(key: 'midOption');
                      await botOption.saveOption(key: 'botOption');

                      ReadScreen.topOption = topOption;
                      ReadScreen.midOption = midOption;
                      ReadScreen.botOption = botOption;
                      Navigator.of(context).pop('save');
                    },
                  ),
                ],
              );
            },
          );

          if (result == 'exit') {
            Navigator.of(context).pop();
          }
        } else {
          Navigator.of(context).pop('saved');
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F4F4),
        appBar: GFAppBar(
          elevation: 0.5,
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () async {
                if (isChanged && !isSaved) {
                  final result = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('확인 필요'),
                        content: const Text('변경사항이 존재하지만, 저장하지 않았습니다.'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('나가기'),
                            onPressed: () {
                              Navigator.of(context).pop('exit');
                            },
                          ),
                          TextButton(
                            child: const Text('저장'),
                            onPressed: () async {
                              await topOption.saveOption(key: 'topOption');
                              await midOption.saveOption(key: 'midOption');
                              await botOption.saveOption(key: 'botOption');

                              ReadScreen.topOption = topOption;
                              ReadScreen.midOption = midOption;
                              ReadScreen.botOption = botOption;
                              Navigator.of(context).pop('save');
                            },
                          ),
                        ],
                      );
                    },
                  );

                  if (result == 'exit') {
                    Navigator.of(context).pop();
                  }
                } else {
                  Navigator.of(context).pop('saved');
                }
              }),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: GFSegmentTabs(
            height: 40,
            width: AppLingua.width / 1.8,
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
            optionPage(
              context: context,
              readOption: topOption,
            ),
            optionPage(
              context: context,
              readOption: midOption,
            ),
            optionPage(
              context: context,
              readOption: botOption,
            ),
          ],
        ),
      ),
    );
  }

  Center optionPage({
    required BuildContext context,
    required ReadOption readOption,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            commonDivider(context),
            Container(
              height: AppLingua.height * 0.2,
              width: AppLingua.width,
              decoration: BoxDecoration(
                color: Color(readOption.optBackgroundColor),
              ),
              child: Center(
                child: Text(
                  '적용 예시입니다.\n각 칸별 설정이 가능합니다.',
                  style: TextStyle(
                    fontSize: readOption.optFontSize,
                    height: readOption.optFontHeight,
                    fontFamily: readOption.optFontFamily,
                    color: Color(readOption.optFontColor),
                  ),
                ),
              ),
            ),
            commonDivider(context),
            optionSingleContainer(
              context: context,
              containerHeight: AppLingua.height * 0.23,
              lines: [
                optionUpDown(
                  labelText: '글자 크기',
                  argText: readOption.optFontSize.toString(),
                  upButtonTap: () {
                    setState(() {
                      !isChanged ? isChanged = true : isChanged;
                      readOption.optFontSize += 0.5;
                    });
                  },
                  downButtonTap: () {
                    setState(() {
                      !isChanged ? isChanged = true : isChanged;
                      readOption.optFontSize -= 0.5;
                    });
                  },
                  upButtonVaild: readOption.optFontSize < 30 ? true : false,
                  downButtonValid: readOption.optFontSize >= 10 ? true : false,
                ),
                optionUpDown(
                  labelText: '줄 간격',
                  argText: readOption.optFontHeight.toStringAsFixed(1),
                  upButtonTap: () {
                    setState(() {
                      !isChanged ? isChanged = true : isChanged;
                      readOption.optFontHeight += 0.1;
                    });
                  },
                  downButtonTap: () {
                    setState(() {
                      !isChanged ? isChanged = true : isChanged;
                      readOption.optFontHeight -= 0.1;
                    });
                  },
                  upButtonVaild: readOption.optFontHeight <= 2.5 ? true : false,
                  downButtonValid: readOption.optFontHeight > 1 ? true : false,
                ),
              ],
            ),
            commonDivider(context),
            optionSingleContainer(
              context: context,
              containerHeight: AppLingua.height * 0.27,
              lines: [
                optionFontSelect(
                  labelText: '폰트 선택',
                  argText: 'asd',
                  readOption: readOption,
                ),
                optionFontColorSelect(
                  labelText: '글자색',
                  readOption: readOption,
                ),
                optionBackgroundSelect(
                  labelText: '배경색',
                  readOption: readOption,
                ),
              ],
            ),
            commonDivider(context),
            Expanded(
                child: optionSingleContainer(
              context: context,
              containerHeight: 10,
              lines: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () async {
                        isSaved = true;
                        await topOption.saveOption(key: 'topOption');
                        await midOption.saveOption(key: 'midOption');
                        await botOption.saveOption(key: 'botOption');
                      },
                      child: Container(
                        width: AppLingua.width * 0.18,
                        height: AppLingua.height * 0.045,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '저장',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: AppLingua.height * 0.018,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
            )),
          ],
        ),
      ),
    );
  }

  Container optionSingleContainer({
    required BuildContext context,
    required double containerHeight,
    List<Widget>? lines,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
  }) {
    return Container(
      width: AppLingua.width,
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
        mainAxisAlignment: mainAxisAlignment,
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
                fontSize: AppLingua.height * 0.024,
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
                    style: TextStyle(
                      fontSize: AppLingua.height * 0.023,
                    ),
                  ),
                ),
                InkWell(
                  onTap: upButtonVaild ? upButtonTap : () {},
                  child: Container(
                    height: AppLingua.height * 0.053,
                    width: AppLingua.width * 0.2,
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
                    height: AppLingua.height * 0.053,
                    width: AppLingua.width * 0.2,
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
    required ReadOption readOption,
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
                  width: AppLingua.width * 0.45,
                  child: DropdownButton(
                    underline: const SizedBox.shrink(),
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      size: AppLingua.height * 0.04,
                    ),
                    value: readOption.optFontFamily,
                    items: _fonts
                        .map((e) => DropdownMenuItem(
                              value: e, // 선택 시 onChanged 를 통해 반환할 value
                              child: Text(
                                e,
                                style: TextStyle(
                                  fontSize: AppLingua.height * 0.021,
                                  fontFamily: _fonts[_fonts.indexOf(e)],
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      // items 의 DropdownMenuItem 의 value 반환
                      setState(() {
                        !isChanged ? isChanged = true : isChanged;
                        readOption.optFontFamily = value!;
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
    required ReadOption readOption,
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
                                !isChanged ? isChanged = true : isChanged;
                                readOption.optFontColor = value;
                              });
                            },
                            child: Container(
                              width: AppLingua.width * 0.13,
                              height: AppLingua.height * 0.036,
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
    required ReadOption readOption,
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
                              !isChanged ? isChanged = true : isChanged;
                              readOption.optBackgroundColor = value;
                            });
                          },
                          child: Container(
                            width: AppLingua.width * 0.13,
                            height: AppLingua.height * 0.036,
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
