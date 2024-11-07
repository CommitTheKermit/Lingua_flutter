import 'package:flutter/material.dart';
import 'package:lingua/models/read_option.dart';
import 'package:lingua/screens_mobile_old/etc_screens/read_option/model/read_option_model.dart';
import 'package:lingua/widgets/commons/common_text.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReadOptionProv extends ChangeNotifier {
  ReadOptionModel model = ReadOptionModel();

  void clear() {
    model = ReadOptionModel();
  }

  void notify() {
    notifyListeners();
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

                        widget.readProv.model.topOption = topOption;
                        widget.readProv.model.midOption = midOption;
                        widget.readProv.model.botOption = botOption;
                        widget.readProv.model.readModeOption = readModeOption;
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
              child: comnText(
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
                    items: model.fonts
                        .map((e) => DropdownMenuItem(
                      value: e, // 선택 시 onChanged 를 통해 반환할 value
                      child: Text(
                        '     $e',
                        style: TextStyle(
                          fontSize: 2.1.h,
                          fontFamily: model.fonts[model.fonts.indexOf(e)],
                        ),
                      ),
                    ))
                        .toList(),
                    onChanged: (value) {
                      // items 의 DropdownMenuItem 의 value 반환

                        !model.isChanged ? model.isChanged = true : model.isChanged;
                        readOption.optFontFamily = value!;
                        notify();

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
              child: comnText(
                labelText: labelText,
                fontSize: 2.h,
              ),
            ),
          ),
          SizedBox(
            width: 70.w,
            child: Padding(
              padding: EdgeInsets.only(
                top: 12,
                right: 15,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: model.fontColors
                      .map(
                        (value) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      child: InkWell(
                        onTap: () {

                            !model.isChanged ? model.isChanged = true : model.isChanged;
                            readOption.optFontColor = value;
                          notify();
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
            child: comnText(
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
                  children: model.backgroundColors
                      .map(
                        (value) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      child: InkWell(
                        onTap: () {
                            !model.isChanged ? model.isChanged = true : model.isChanged;
                            readOption.optBackgroundColor = value;
                          notify();
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
  Color getComplementaryColor(Color color) {
    int r = 255 - color.red;
    int g = 255 - color.green;
    int b = 255 - color.blue;
    return Color.fromRGBO(r, g, b, 1); // Alpha 값을 1로 설정하여 완전 불투명하게 만듭니다.
  }
}
