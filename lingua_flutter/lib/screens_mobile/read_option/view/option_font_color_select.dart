import 'package:flutter/material.dart';
import 'package:lingua/models/read_option.dart';
import 'package:lingua/screens_mobile/read_option/view_model/read_option_prov.dart';
import 'package:lingua/widgets/commons/common_text.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OptionFontColorSelect extends StatefulWidget {
  const OptionFontColorSelect({
    Key? key,
    required this.labelText,
    required this.readOption,
  }) : super(key: key);

  final String labelText;
  final ReadOption readOption;
  @override
  State<OptionFontColorSelect> createState() => _OptionFontColorSelectState();
}

class _OptionFontColorSelectState extends State<OptionFontColorSelect> {
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
            padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Center(
              child: comnText(
                labelText: widget.labelText,
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
                  children: optionProv.model.fontColors
                      .map(
                        (value) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          child: InkWell(
                            onTap: () {
                              !optionProv.model.isChanged
                                  ? optionProv.model.isChanged = true
                                  : optionProv.model.isChanged;
                              widget.readOption.optFontColor = value;
                              optionProv.notify();
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
                                widget.readOption.optFontColor == value
                                    ? Icon(
                                        Icons.check,
                                        color: optionProv.getComplementaryColor(
                                            Color(value)),
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
}
