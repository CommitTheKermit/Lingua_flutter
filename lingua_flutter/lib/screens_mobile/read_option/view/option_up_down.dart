import 'package:flutter/material.dart';
import 'package:lingua/widgets/commons/common.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OptionUpDown extends StatefulWidget {
  const OptionUpDown({
    Key? key,
    required this.labelText,
    required this.upButtonTap,
    required this.downButtonTap,
    required this.argText,
    required this.upButtonVaild,
    required this.downButtonValid,
  }) : super(key: key);
  final String labelText;
  final Function() upButtonTap;
  final Function() downButtonTap;
  final String argText;
  final bool upButtonVaild;
  final bool downButtonValid;
  @override
  State<OptionUpDown> createState() => _OptionUpDownState();
}

class _OptionUpDownState extends State<OptionUpDown> {
  @override
  Widget build(BuildContext context) {
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
                widget.labelText,
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
                    onPressed:
                        widget.downButtonValid ? widget.downButtonTap : () {},
                    icon: widget.downButtonValid
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
                      widget.argText,
                      style: TextStyle(
                        fontSize: 2.3.h,
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed:
                        widget.upButtonVaild ? widget.upButtonTap : () {},
                    icon: widget.upButtonVaild
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
