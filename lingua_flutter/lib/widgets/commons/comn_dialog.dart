import 'package:flutter/material.dart';
import 'package:lingua/main/main_theme.dart';
import 'package:lingua/widgets/commons/common.dart';
import 'package:lingua/widgets/commons/wrap_text.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

enum ComnDialogType { single, pair, none }

class ComnDialog extends StatefulWidget {
  const ComnDialog({
    super.key,
    required this.type,
    /* 선택창 1개 , 2개 여부*/
    required this.title,
    /* 타이틀 */
    required this.contents,
    /* 컨텐츠*/
    this.onLeftTap,
    /* 왼쪽 버튼 클릭 이벤트*/
    this.onRightTap,
    /* 오른쪽 or 1개 버튼 클릭 이벤트*/
    this.leftContents = '닫기',
    /* 왼쪽버튼 텍스트*/
    this.rightContents = '확인',
    /* 오른쪽 or 1개 버튼 텍스트 */
    this.customTitle,
    /* 커스텀 타이틀 정의 */
    this.customContents,
    /* 커스텀 컨텐츠 정의 */
    this.customTitlePadding,
    /* 커스텀 타이틀 패딩 정의 */
    this.customContentsPadding,
    /* 커스텀 컨텐츠 패딩 정의 */
    this.customMargin = 35,
    /*커스텀 전체 좌우 여백*/
    this.isScrollable,
    this.scrollController,
    this.customButtonHeight = 58,
    this.showExitButton = false,
    this.buttonTextStyle,

    ///팝업 최대 크기
  });

  final String title;
  final String contents;

  final ComnDialogType type;

  /* single ,pair */
  final Function()? onLeftTap;
  final Function()? onRightTap;
  final String leftContents;
  final String rightContents;
  final Widget? customTitle;
  final Widget? customContents;
  final EdgeInsetsGeometry? customTitlePadding;
  final EdgeInsetsGeometry? customContentsPadding;
  final int customMargin;
  final bool? isScrollable;
  final ScrollController? scrollController;
  final double? customButtonHeight;
  final bool? showExitButton;
  final TextStyle? buttonTextStyle;

  @override
  State<StatefulWidget> createState() => _ComnDialogState();
}

class _ComnDialogState extends State<ComnDialog> with TickerProviderStateMixin {
  @override
  void didUpdateWidget(covariant ComnDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.showExitButton!
            ? GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.zero,
                  // padding: EdgeInsets.only(
                  //   left: widget.customMargin.toDouble(),
                  //   right: widget.customMargin.toDouble(),
                  //   top: 0,
                  //   bottom: 10,
                  // ),
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        comnText(
                          '닫기',
                          colorFont: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 0.3.h),
                          child: Image.asset(
                            'assets/common/ic_close_dialog.png',
                            width: 3.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100.w,
                margin: EdgeInsets.symmetric(
                  horizontal: widget.customMargin.toDouble(),
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    topLeft: Radius.circular(5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: widget.customTitlePadding ?? const EdgeInsets.all(30),
                      child: Center(
                        child: widget.customTitle ??
                            Text(
                              widget.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900, // 텍스트 강조 설정
                                color: MAIN_TEXT_COLOR,
                                height: 1.6,
                                letterSpacing: 1,
                              ),
                            ),
                      ),
                    ),
                    Container(
                      padding:
                          widget.customContentsPadding ?? const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      constraints: const BoxConstraints(
                          // maxHeight: widget.customMaxHeight,
                          ),
                      child: widget.isScrollable == true
                          ? SingleChildScrollView(
                              controller: widget.scrollController,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: widget.customContents ??
                                      WrapText(
                                        widget.contents,
                                        align: WrapAlignment.center,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold, // 텍스트 강조 설정
                                          color: MAIN_TEXT_COLOR,
                                          height: 1.6,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                ),
                              ),
                            )
                          : Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: widget.customContents ??
                                    WrapText(
                                      widget.contents,
                                      align: WrapAlignment.center,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold, // 텍스트 강조 설정
                                        color: MAIN_TEXT_COLOR,
                                        height: 1.6,
                                        letterSpacing: 1,
                                      ),
                                    ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              widget.type == ComnDialogType.single
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: widget.customMargin.toDouble()),
                      child: Ink(
                        decoration: const BoxDecoration(
                          color: MAIN_APP_COLOR,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          ),
                        ),
                        child: InkWell(
                          onLongPress: () {},
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          ),
                          onTap: () {
                            widget.onRightTap?.call();
                          },
                          child: SizedBox(
                            // padding: const EdgeInsets.fromLTRB(0, 20, 0, 19),
                            width: 100.w - (widget.customMargin.round() * 2),
                            height: widget.customButtonHeight,
                            child: Center(
                              child: Text(
                                widget.rightContents,
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : widget.type == ComnDialogType.pair
                      ? Row(
                          children: [
                            SizedBox(width: widget.customMargin.toDouble()),
                            Ink(
                              decoration: const BoxDecoration(
                                color: Color(0xffcccccc),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                ),
                              ),
                              child: InkWell(
                                onLongPress: () {},
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                ),
                                onTap: () {
                                  widget.onLeftTap?.call();
                                  //                    Navigator.pop(context);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 100.w / 2 - widget.customMargin.round(),
                                  height: widget.customButtonHeight,
                                  child: Center(
                                    child: Text(
                                      widget.leftContents,
                                      textAlign: TextAlign.center,
                                      style: widget.buttonTextStyle ??
                                          const TextStyle(
                                              fontSize: 17,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Ink(
                              decoration: const BoxDecoration(
                                color: MAIN_APP_COLOR,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
                              child: InkWell(
                                onLongPress: () {},
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(5),
                                ),
                                onTap: () {
                                  widget.onRightTap?.call();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 100.w / 2 - widget.customMargin.round(),
                                  height: widget.customButtonHeight,
                                  child: Center(
                                    child: Text(
                                      widget.rightContents,
                                      textAlign: TextAlign.center,
                                      style: widget.buttonTextStyle ??
                                          const TextStyle(
                                              fontSize: 17,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: widget.customMargin.toDouble()),
                          ],
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: widget.customMargin.toDouble()),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                            ),
                            width: 100.w - (widget.customMargin.round() * 2),
                            height: 10,
                          ),
                        )
            ],
          ),
        ),
      ],
    );
  }
}
