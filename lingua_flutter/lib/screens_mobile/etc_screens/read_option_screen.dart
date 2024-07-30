
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lingua/models/read_option.dart';
import 'package:lingua/screens_mobile/main_screens/read_screen.dart';
import 'package:lingua/widgets/commons/common_divider.dart';
import 'package:lingua/widgets/commons/common_text.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReadOptionScreen extends StatefulWidget {
  final int startingTab;
  const ReadOptionScreen({super.key, required this.startingTab});

  @override
  State<ReadOptionScreen> createState() => _ReadOptionScreenState();
}

class _ReadOptionScreenState extends State<ReadOptionScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  ReadOption topOption = ReadScreen.topOption.clone();
  ReadOption midOption = ReadScreen.midOption.clone();
  ReadOption botOption = ReadScreen.botOption.clone();
  ReadOption readModeOption = ReadScreen.readModeOption.clone();

  bool isChanged = false;
  bool isSaved = false;

  String _selectedFont = '';
  final _fonts = [
    'Neo',
    'Noto Sans',
    'Gangwon',
    'Gmarket',
    'Hakgyo',
    'Jaemin',
    'Pretendard',
  ];

  final backgroundColors = [
    0xFFFFFFFF,
    0xFF4A4A4A,
    0xFF2A2A2A,
    0xFFE9E5DA,
    0xFFE4D0BE,
    0xFFC3B083,
    0xFFCFCED3,
    0xFFD1DCEA,
  ];
  final fontColors = [
    0xFFFFFFFF,
    0xFF4A4A4A,
    0xFF2A2A2A,
    0xFF716B5D,
    0xFF7B6755,
    0xFF645636,
    0xFF514D63,
    0xFF465568
  ];

  Color getComplementaryColor(Color color) {
    int r = 255 - color.red;
    int g = 255 - color.green;
    int b = 255 - color.blue;
    return Color.fromRGBO(r, g, b, 1); // Alpha 값을 1로 설정하여 완전 불투명하게 만듭니다.
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);

    setState(() {
      tabController.animateTo(widget.startingTab);
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
      appBar: AppBar(
        centerTitle: true,
        title: commonText(
          labelText: '읽기 옵션',
          fontColor: const Color(0xFF171A1D),
          fontSize: 2.25.h,
          fontWeight: FontWeight.w700,
        ),
        actions: [
          TextButton(
              onPressed: () async {
                isSaved = true;
                await topOption.saveOption(key: 'topOption');
                await midOption.saveOption(key: 'midOption');
                await botOption.saveOption(key: 'botOption');
                await readModeOption.saveOption(key: 'readModeOption');
              },
              child: Text(
                '저장',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isChanged
                      ? const Color(0xFF1E4A75)
                      : const Color(0xFF868E96),
                  fontSize: 2.h,
                ),
              ))
        ],
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () async {
            String? result = '';
            if (isChanged && !isSaved) {
              result = await askDialog(context);

              if (result == 'exit') {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pop('saved');
              }
            } else {
              Navigator.of(context).pop('unchanged');
            }
          },
          icon: Image.asset(
            'assets/images/icon_back.png',
            width: 2.75.h,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          String? result = '';
          if (isChanged && !isSaved) {
            result = await askDialog(context);
            if (result == 'exit') {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pop('saved');
            }
          } else {
            Navigator.of(context).pop('unchanged');
          }

          return false;
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F4F4),
          appBar: GFAppBar(
            automaticallyImplyLeading: false,
            elevation: 0.5,
            backgroundColor: Colors.white,
            centerTitle: true,
            titleSpacing: 0,
            title: GFSegmentTabs(
              height: 6.75.h,
              width: 100.w,
              tabController: tabController,
              tabBarColor: GFColors.WHITE,
              labelColor: GFColors.WHITE,
              unselectedLabelColor: GFColors.DARK,
              indicator: const BoxDecoration(
                color: Color(0xFF44698F),
              ),
              border: Border.all(color: GFColors.DARK, width: 0.3),
              length: 4,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                _singleTabButton(argText: '상단'),
                _singleTabButton(argText: '중단'),
                _singleTabButton(argText: '하단'),
                _singleTabButton(argText: '뷰어'),
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
              optionPage(
                context: context,
                readOption: readModeOption,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> askDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.zero,
          title: Text(
            '확인 필요',
            style: TextStyle(
              color: const Color(0xFF171A1D),
              fontSize: 2.25.h,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: SizedBox(
            width: 80.w,
            height: 8.h,
            child: Text(
              '변경사항이 존재하지만, 저장하지 않았습니다.',
              style: TextStyle(
                color: const Color(0xFF171A1D),
                fontSize: 2.h,
              ),
            ),
          ),
          actions: [
            Container(
              height: 6.75.h,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.5, color: Color(0xFFDEE2E6)),
                ),
              ),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop('exit');
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(
                                width: 1.5, color: Color(0xFFDEE2E6)),
                          ),
                        ),
                        child: Center(
                            child: Text(
                          '나가기',
                          style: TextStyle(
                            color: const Color(0xFF43698F),
                            fontSize: 2.25.h,
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: InkWell(
                      onTap: () async {
                        await topOption.saveOption(key: 'topOption');
                        await midOption.saveOption(key: 'midOption');
                        await botOption.saveOption(key: 'botOption');
                        await readModeOption.saveOption(key: 'readModeOption');

                        ReadScreen.topOption = topOption;
                        ReadScreen.midOption = midOption;
                        ReadScreen.botOption = botOption;
                        ReadScreen.readModeOption = readModeOption;
                        Navigator.of(context).pop('save');
                      },
                      child: SizedBox(
                        height: 6.75.h,
                        child: Center(
                            child: Text(
                          '저장',
                          style: TextStyle(
                            color: const Color(0xFF43698F),
                            fontSize: 2.25.h,
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
    return result;
  }

  SizedBox _singleTabButton({required String argText}) {
    return SizedBox(
      child: Center(
        child: Text(
          argText,
          style: TextStyle(fontSize: 2.125.h),
        ),
      ),
    );
  }

  Center optionPage({
    required BuildContext context,
    required ReadOption readOption,
  }) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 100.w,
            height: 4.5.h,
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 3.w),
                child: Text(
                  '설정 미리보기',
                  style: TextStyle(
                    color: const Color(0xFF868E96),
                    fontSize: 1.75.h,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 26.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: Color(readOption.optBackgroundColor),
            ),
            child: SingleChildScrollView(
              child: Center(
                child: Text(
                  '적용 예시입니다.\n각 칸별 설정이 가능합니다.\n\nThis is an application example.\nEach column can be set',
                  style: TextStyle(
                    fontSize: readOption.optFontSize,
                    height: readOption.optFontHeight,
                    fontFamily: readOption.optFontFamily,
                    color: Color(readOption.optFontColor),
                  ),
                ),
              ),
            ),
          ),
          commonDivider(),
          Container(
            width: 100.w,
            height: 4.5.h,
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 3.w),
                child: Text(
                  '폰트 설정',
                  style: TextStyle(
                    color: const Color(0xFF868E96),
                    fontSize: 1.75.h,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          optionSingleContainer(
            mainAxisAlignment: MainAxisAlignment.start,
            context: context,
            containerHeight: 25.h,
            lines: [
              optionFontSelect(
                labelText: '폰트 선택',
                argText: '',
                readOption: readOption,
              ),
              optionBackgroundSelect(
                labelText: '배경색',
                readOption: readOption,
              ),
              optionFontColorSelect(
                labelText: '글자색',
                readOption: readOption,
              ),
            ],
          ),
          commonDivider(),
          Expanded(
            child: optionSingleContainer(
              mainAxisAlignment: MainAxisAlignment.start,
              context: context,
              containerHeight: 15.h,
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
          ),
        ],
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
      width: 100.w,
      height: containerHeight,
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
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
        mainAxisSize: MainAxisSize.min,
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
        bottom: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 1.25.h,
              left: 15,
            ),
            child: Center(
              child: commonText(
                labelText: labelText,
                fontSize: 2.h,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 1.25.h,
              right: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: downButtonValid ? downButtonTap : () {},
                    icon: downButtonValid
                        ? Image.asset(
                            'assets/images/valid_minus.png',
                            height: 3.5.h,
                          )
                        : Image.asset(
                            'assets/images/invalid_minus.png',
                            height: 3.5.h,
                          )),
                SizedBox(
                  width: 20.w,
                  child: Center(
                    child: Text(
                      argText,
                      style: TextStyle(
                        fontSize: 2.3.h,
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: upButtonVaild ? upButtonTap : () {},
                    icon: upButtonVaild
                        ? Image.asset(
                            'assets/images/valid_add.png',
                            height: 3.5.h,
                          )
                        : Image.asset(
                            'assets/images/invalid_add.png',
                            height: 3.5.h,
                          )),
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
              left: 15,
            ),
            child: Center(
              child: commonText(
                labelText: labelText,
                fontSize: 2.h,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 15,
            ),
            child: Row(
              children: [
                Container(
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF8F9FA),
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFFDEE2E6)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  width: 65.w,
                  child: DropdownButton(
                    underline: const SizedBox.shrink(),
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 4.h,
                    ),
                    value: readOption.optFontFamily,
                    items: _fonts
                        .map((e) => DropdownMenuItem(
                              value: e, // 선택 시 onChanged 를 통해 반환할 value
                              child: Text(
                                '     $e',
                                style: TextStyle(
                                  fontSize: 2.1.h,
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
                fontSize: 2.h,
              ),
            ),
          ),
          SizedBox(
            width: 70.w,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 12,
                right: 15,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: fontColors
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
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 13.w,
                                  height: 3.6.h,
                                  decoration: ShapeDecoration(
                                    color: Color(
                                      value,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(width: 0.5),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                readOption.optFontColor == value
                                    ? Icon(
                                        Icons.check,
                                        color:
                                            getComplementaryColor(Color(value)),
                                      )
                                    : const SizedBox.shrink(),
                              ],
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
              fontSize: 2.h,
            ),
          ),
        ),
        SizedBox(
          width: 70.w,
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
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 13.w,
                                  height: 3.6.h,
                                  decoration: ShapeDecoration(
                                    color: Color(
                                      value,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(width: 0.5),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                readOption.optBackgroundColor == value
                                    ? Icon(
                                        Icons.check,
                                        color:
                                            getComplementaryColor(Color(value)),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList()),
            ),
          ),
        )
      ],
    );
  }
}
