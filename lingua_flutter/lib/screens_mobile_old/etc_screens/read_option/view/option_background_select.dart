import 'package:flutter/material.dart';
import 'package:lingua/models/read_option.dart';
import 'package:lingua/screens_mobile_old/etc_screens/read_option/view_model/read_option_prov.dart';
import 'package:lingua/widgets/commons/common_text.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OptionBackgroundSelect extends StatefulWidget {
  const OptionBackgroundSelect({
    Key? key,
    required this.labelText,
    required this.readOption,
  }) : super(key: key);

  final String labelText;
  final ReadOption readOption;
  @override
  State<OptionBackgroundSelect> createState() => _OptionBackgroundSelectState();
}

class _OptionBackgroundSelectState extends State<OptionBackgroundSelect> {
  @override
  Widget build(BuildContext context) {
    ReadOptionProv optionProv = Provider.of<ReadOptionProv>(context);
    return Row(
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
            padding: const EdgeInsets.only(
              top: 12,
              right: 15,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: optionProv.model.backgroundColors
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
                              widget.readOption.optBackgroundColor = value;
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
                                widget.readOption.optBackgroundColor == value
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
                      .toList()),
            ),
          ),
        )
      ],
    );
  }
}
