import 'package:flutter/material.dart';
import 'package:lingua/models/read_option.dart';
import 'package:lingua/screens_mobile/read_option/view_model/read_option_prov.dart';
import 'package:lingua/widgets/commons/common_text.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OptionFontSelect extends StatefulWidget {
  const OptionFontSelect({
    Key? key,
    required this.labelText,
    required this.argText,
    required this.readOption,
  }) : super(key: key);
  final String labelText;
  final String argText;
  final ReadOption readOption;
  @override
  State<OptionFontSelect> createState() => _OptionFontSelectState();
}

class _OptionFontSelectState extends State<OptionFontSelect> {
  @override
  Widget build(BuildContext context) {
    ReadOptionProv optionProv = Provider.of<ReadOptionProv>(context);
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
                labelText: widget.labelText,
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
                    value: widget.readOption.optFontFamily,
                    items: optionProv.model.fonts
                        .map((e) => DropdownMenuItem(
                              value: e, // 선택 시 onChanged 를 통해 반환할 value
                              child: Text(
                                '     $e',
                                style: TextStyle(
                                  fontSize: 2.1.h,
                                  fontFamily: optionProv.model
                                      .fonts[optionProv.model.fonts.indexOf(e)],
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      // items 의 DropdownMenuItem 의 value 반환

                      !optionProv.model.isChanged
                          ? optionProv.model.isChanged = true
                          : optionProv.model.isChanged;
                      widget.readOption.optFontFamily = value!;
                      optionProv.notify();
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
}
