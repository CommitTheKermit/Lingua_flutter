import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lingua/main.dart';
import 'package:lingua/screens_mobile/home/view_model/home_prov.dart';
import 'package:lingua/screens_mobile/read_option/view/option_page.dart';
import 'package:lingua/screens_mobile/read_option/view/single_tab_button.dart';
import 'package:lingua/screens_mobile/read_option/view_model/read_option_prov.dart';
import 'package:lingua/widgets/commons/common.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReadOptionScreen extends StatefulWidget {
  const ReadOptionScreen({
    super.key,
    required this.startingTab,
    required this.readProv,
  });
  final int startingTab;
  final HomeProv readProv;

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
           '읽기 옵션',
          colorFont: const Color(0xFF171A1D),
          fontSize: 2.25.h,
          weightFont: FontWeight.w700,
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
              tabs: const [
                SingleTabButton(argText: '상단'),
                SingleTabButton(argText: '중단'),
                SingleTabButton(argText: '하단'),
                SingleTabButton(argText: '뷰어'),
              ],
            ),
          ),
          body: GFTabBarView(
            controller: optionProv.model.tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              OptionPage(
                readOption: optionProv.model.topOption,
              ),
              OptionPage(
                readOption: optionProv.model.midOption,
              ),
              OptionPage(
                readOption: optionProv.model.botOption,
              ),
              OptionPage(
                readOption: optionProv.model.readModeOption,
              ),
            ],
          ),
        ),
      ),
    );
  }



}
