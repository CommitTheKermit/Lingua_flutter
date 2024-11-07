import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lingua/main.dart';
import 'package:lingua/models/read_option.dart';
import 'package:lingua/screens_mobile/read_screen/view/read.dart';
import 'package:lingua/screens_mobile/read_screen/view_model/read_prov.dart';
import 'package:lingua/screens_mobile_old/etc_screens/read_option/view_model/read_option_prov.dart';
import 'package:lingua/widgets/commons/common_divider.dart';
import 'package:lingua/widgets/commons/common_text.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReadOptionScreen extends StatefulWidget {
  const ReadOptionScreen({
    super.key,
    required this.startingTab,
    required this.readProv,
  });
  final int startingTab;
  final ReadProv readProv;

  @override
  State<ReadOptionScreen> createState() => _ReadOptionScreenState();
}

class _ReadOptionScreenState extends State<ReadOptionScreen>
    with TickerProviderStateMixin {


  @override
  void initState() {
    super.initState();
    ReadOptionProv optionProv =
        Provider.of<ReadOptionProv>(globalContext, listen: false);
    optionProv.model.tabController = TabController(length: 4, vsync: this);
    optionProv.model.topOption = widget.readProv.model.topOption;
    optionProv.model.midOption = widget.readProv.model.midOption;
    optionProv.model.botOption = widget.readProv.model.botOption;
    optionProv.model.readModeOption = widget.readProv.model.readModeOption;

    setState(() {
      optionProv.model.tabController.animateTo(widget.startingTab);
      optionProv.model.selectedFont = optionProv.model.fonts[0];
    });
  }

  @override
  void dispose() {
    ReadOptionProv optionProv =
        Provider.of<ReadOptionProv>(globalContext, listen: false);
    optionProv.model.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ReadOptionProv optionProv = Provider.of<ReadOptionProv>(globalContext);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: comnText(
          labelText: '읽기 옵션',
          fontColor: const Color(0xFF171A1D),
          fontSize: 2.25.h,
          fontWeight: FontWeight.w700,
        ),
        actions: [
          TextButton(
              onPressed: () async {
                optionProv.model.isSaved = true;
                await optionProv.model.topOption.saveOption(key: 'topOption');
                await optionProv.model.midOption.saveOption(key: 'midOption');
                await optionProv.model.botOption.saveOption(key: 'botOption');
                await optionProv.model.readModeOption.saveOption(key: 'readModeOption');
              },
              child: Text(
                '저장',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: optionProv.model.isChanged
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
            if (optionProv.model.isChanged && !optionProv.model.isSaved) {
              result = await optionProv.askDialog(context);

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
          if (optionProv.model.isChanged && !optionProv.model.isSaved) {
            result = await optionProv.askDialog(context);
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
              tabController: optionProv.model.tabController,
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
                singleTabButton(argText: '상단'),
                singleTabButton(argText: '중단'),
                singleTabButton(argText: '하단'),
                singleTabButton(argText: '뷰어'),
              ],
            ),
          ),
          body: GFTabBarView(
            controller: optionProv.model.tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              optionPage(
                context: context,
                readOption: optionProv.model.topOption,
              ),
              optionPage(
                context: context,
                readOption: optionProv.model.midOption,
              ),
              optionPage(
                context: context,
                readOption: optionProv.model.botOption,
              ),
              optionPage(
                context: context,
                readOption: optionProv.model.readModeOption,
              ),
            ],
          ),
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
              child: comnText(
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


}
