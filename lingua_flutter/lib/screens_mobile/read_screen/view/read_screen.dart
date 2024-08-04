import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/models/user_model.dart';
import 'package:lingua/screens_mobile/read_screen/view/appbar/read_app_bar.dart';
import 'package:lingua/screens_mobile/read_screen/view/main_read_drawer.dart';
import 'package:lingua/screens_mobile/read_screen/view_model/read_screen_prov.dart';

import 'package:lingua/utils/api/api_user.dart';
import 'package:lingua/utils/etc/exit_confirm.dart';
import 'package:lingua/utils/file_process/translate_input_process.dart';
import 'package:lingua/widgets/commons/common_divider.dart';
import 'package:lingua/widgets/read_widgets/call_limit_widget.dart';
import 'package:lingua/widgets/read_widgets/read_button_widget.dart';
import 'package:lingua/widgets/read_widgets/text_field_widget.dart';
import 'package:lingua/widgets/read_widgets/translated_field_widget.dart';
import 'package:lingua/widgets/read_widgets/words_widget.dart';
import 'package:lingua/utils/etc/error_toast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReadScreen extends StatefulWidget {
  const ReadScreen({
    super.key,
    required this.readProv,
  });

  final ReadScreenProv readProv;

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  // handle app lifecycle state change (pause/resume)
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        if (!widget.readProv.model.STOP_REFRESH) {
          periodicRefresh(email: UserModel.email).then((value) {
            widget.readProv.model.requestQuota.value = value;
          });
        }

        break;

      default:
    }
  }

  @override
  void initState() {
    super.initState();
    widget.readProv.model.refreshPeriodSecond =
        widget.readProv.model.refreshPeriodMinute * 60;
    if (!widget.readProv.model.STOP_REFRESH) {
      periodicRefresh(email: UserModel.email).then((value) {
        widget.readProv.model.requestQuota.value = value;
      });
    }

    WidgetsBinding.instance.addObserver(this);
    widget.readProv.model.index = 0;
    widget.readProv.model.futureOption = widget.readProv.initOption();
    widget.readProv.schedulePeriodicTask();
  }

  @override
  void dispose() {
    super.dispose();
    widget.readProv.model.scrollController.dispose();
    widget.readProv.model.scrollTimerController.dispose();
    widget.readProv.model.serverRequestTimer.cancel();
    widget.readProv.model.countdownTimer.cancel();
    widget.readProv.model.requestQuota.dispose();
    widget.readProv.model.machineTranslated.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    ReadScreenProv readProv = widget.readProv;

    readProv.buildRefresh();

    return FutureBuilder(
      future: readProv.model.futureOption,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(6.h),
              child: const ReadAppBar(),
            ),
            drawer: const MainReadDrawer(),
            body: PopScope(
              onPopInvoked: (didPop) async {
                exitConfirm(context);
              },
              child: Column(
                children: [
                  commonDivider(),
                  TextFieldWidget(
                    argText: readProv.model.originalSingleSentence.isNotEmpty
                        ? readProv.model.originalSingleSentence
                        : '원문 출력칸',
                    flexValue: readProv.model.originalTextFieldFlex,
                    readOption: readProv.model.topOption,
                    currentIndex:
                        readProv.model.isNovelLoaded ? readProv.model.index : 0,
                    endIndex: readProv.model.isNovelLoaded
                        ? originalSentences.length
                        : 0,
                  ),
                  readProv.model.isAllowTranslate
                      ? commonDivider()
                      : const SizedBox.shrink(),
                  readProv.model.isAllowTranslate
                      ? Flexible(
                          fit: FlexFit.tight,
                          flex: readProv.model.translatedTextFieldFlex,
                          child: ValueListenableBuilder(
                            valueListenable: readProv.model.machineTranslated,
                            builder: (context, value, child) {
                              if (value.isEmpty &&
                                  readProv.model.isNovelLoaded &&
                                  readProv.model.isAllowTranslate) {
                                return Stack(
                                  children: [
                                    TranslatedFieldWidget(
                                      argText: '로딩 중...',
                                      readOption: readProv.model.midOption,
                                    ),
                                    Positioned(
                                      child: Container(
                                        constraints:
                                            const BoxConstraints.expand(),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(
                                            0.5,
                                          ),
                                        ),
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              } else {
                                return TranslatedFieldWidget(
                                  argText: value.isEmpty ? '번역 출력 부분' : value,
                                  readOption: readProv.model.midOption,
                                );
                              }
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                  readProv.model.isAllowInput
                      ? commonDivider()
                      : const SizedBox.shrink(),
                  readProv.model.isAllowInput
                      ? Flexible(
                          fit: FlexFit.tight,
                          flex: readProv.model.inputFieldFlex,
                          child: Container(
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: Color(
                                  readProv.model.botOption.optBackgroundColor),
                            ),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: TextFormField(
                                  controller: readProv.model.inputController,
                                  style: const TextStyle(
                                    fontSize: 23,
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  key: readProv.model.formKey,
                                  decoration: InputDecoration(
                                      hintText: '번역문 입력칸',
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        fontSize: readProv
                                            .model.botOption.optFontSize,
                                        height: readProv
                                            .model.botOption.optFontHeight,
                                        color: Color(readProv
                                            .model.botOption.optFontColor),
                                        fontFamily: readProv
                                            .model.botOption.optFontFamily,
                                      )),
                                  validator: (value) {
                                    readProv.model.translatedSentence = value!;
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  commonDivider(),
                  wordsWidget(
                    wordsScrollFlex: readProv.model.wordsScrollFlex,
                    words: readProv.model.words,
                    scrollController: readProv.model.scrollController,
                    originalSingleSentence:
                        readProv.model.originalSingleSentence,
                  ),
                  commonDivider(),
                  callLimitWidget(
                      callLimitFlex: readProv.model.callLimitFlex,
                      scrollTimerController:
                          readProv.model.scrollTimerController,
                      requestQuota: readProv.model.requestQuota,
                      remainingTime: readProv.model.remainingTime),
                  commonDivider(),
                  Flexible(
                    flex: readProv.model.buttonsFlex,
                    child: Container(
                      height: double.infinity,
                      width: 100.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ReadButtonWidget(
                              indexLimit: readProv.model.index == 0 &&
                                  !readProv.model.isNovelLoaded,
                              onTapFunc: readProv.model.index == 0
                                  ? () {}
                                  : () {
                                      readProv.lineShift(shiftAmount: -1);
                                    },
                              imageFileOff: 'assets/images/off_prev_button.png',
                              imageFileOn: 'assets/images/on_prev_button.png',
                            ),
                            ReadButtonWidget(
                              indexLimit: readProv.model.index ==
                                      originalSentences.length &&
                                  !readProv.model.isNovelLoaded,
                              onTapFunc: readProv.model.index ==
                                      originalSentences.length
                                  ? () {}
                                  : () {
                                      readProv.lineShift(
                                        shiftAmount: 1,
                                      );
                                    },
                              imageFileOff: 'assets/images/off_next_button.png',
                              imageFileOn: 'assets/images/on_next_button.png',
                            ),
                            ReadButtonWidget(
                              indexLimit: !readProv.model.isNovelLoaded,
                              onTapFunc: () {
                                if (readProv
                                    .model.inputController.text.isNotEmpty) {
                                  inputJson[readProv
                                          .model.originalSingleSentence] =
                                      readProv.model.inputController.text;
                                  saveMapToFile(
                                      map: inputJson,
                                      filename: '${titleNovel}_input.json');
                                } else {
                                  errorToast(argText: '입력칸이 비어 있습니다.');
                                }
                              },
                              imageFileOff:
                                  'assets/images/off_enter_button.png',
                              imageFileOn: 'assets/images/on_enter_button.png',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
