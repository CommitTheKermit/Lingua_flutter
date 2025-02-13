import 'package:flutter/material.dart';
import 'package:lingua/models/read_option.dart';
import 'package:lingua/screens_mobile/read_option/view/option_background_select.dart';
import 'package:lingua/screens_mobile/read_option/view/option_font_color_select.dart';
import 'package:lingua/screens_mobile/read_option/view/option_font_select.dart';
import 'package:lingua/screens_mobile/read_option/view/option_single_container.dart';
import 'package:lingua/screens_mobile/read_option/view/option_up_down.dart';
import 'package:lingua/screens_mobile/read_option/view_model/read_option_prov.dart';
import 'package:lingua/widgets/commons/common.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OptionPage extends StatefulWidget {
  const OptionPage({
    Key? key,
    required this.readOption,
  }) : super(key: key);
  final ReadOption readOption;
  @override
  State<OptionPage> createState() => _OptionPageState();
}

class _OptionPageState extends State<OptionPage> {
  @override
  Widget build(BuildContext context) {
    ReadOptionProv optionProv = Provider.of<ReadOptionProv>(context);
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
              color: Color(widget.readOption.optBackgroundColor),
            ),
            child: SingleChildScrollView(
              child: Center(
                child: Text(
                  '적용 예시입니다.\n각 칸별 설정이 가능합니다.\n\nThis is an application example.\nEach column can be set',
                  style: TextStyle(
                    fontSize: widget.readOption.optfontSize,
                    height: widget.readOption.optFontHeight,
                    fontFamily: widget.readOption.optFontFamily,
                    color: Color(widget.readOption.optcolorFont),
                  ),
                ),
              ),
            ),
          ),
          comnDivider(),
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
          OptionSingleContainer(
            mainAxisAlignment: MainAxisAlignment.start,
            containerHeight: 25.h,
            lines: [
              OptionFontSelect(
                labelText: '폰트 선택',
                argText: '',
                readOption: widget.readOption,
              ),
              OptionBackgroundSelect(
                labelText: '배경색',
                readOption: widget.readOption,
              ),
              OptioncolorFontSelect(
                labelText: '글자색',
                readOption: widget.readOption,
              ),
            ],
          ),
          comnDivider(),
          Expanded(
            child: OptionSingleContainer(
              mainAxisAlignment: MainAxisAlignment.start,
              containerHeight: 15.h,
              lines: [
                OptionUpDown(
                  labelText: '글자 크기',
                  argText: widget.readOption.optfontSize.toString(),
                  upButtonTap: () {
                    setState(() {
                      !optionProv.model.isChanged
                          ? optionProv.model.isChanged = true
                          : optionProv.model.isChanged;
                      widget.readOption.optfontSize += 0.5;
                    });
                  },
                  downButtonTap: () {
                    setState(() {
                      !optionProv.model.isChanged
                          ? optionProv.model.isChanged = true
                          : optionProv.model.isChanged;
                      widget.readOption.optfontSize -= 0.5;
                    });
                  },
                  upButtonVaild: widget.readOption.optfontSize < 30 ? true : false,
                  downButtonValid: widget.readOption.optfontSize >= 10 ? true : false,
                ),
                OptionUpDown(
                  labelText: '줄 간격',
                  argText: widget.readOption.optFontHeight.toStringAsFixed(1),
                  upButtonTap: () {
                    setState(() {
                      !optionProv.model.isChanged
                          ? optionProv.model.isChanged = true
                          : optionProv.model.isChanged;
                      widget.readOption.optFontHeight += 0.1;
                    });
                  },
                  downButtonTap: () {
                    setState(() {
                      !optionProv.model.isChanged
                          ? optionProv.model.isChanged = true
                          : optionProv.model.isChanged;
                      widget.readOption.optFontHeight -= 0.1;
                    });
                  },
                  upButtonVaild: widget.readOption.optFontHeight <= 2.5 ? true : false,
                  downButtonValid: widget.readOption.optFontHeight > 1 ? true : false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
