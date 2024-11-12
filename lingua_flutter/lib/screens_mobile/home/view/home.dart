import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/models/user_model.dart';
import 'package:lingua/screens_mobile/home/view/appbar/home_app_bar.dart';
import 'package:lingua/screens_mobile/home/view/home_read_drawer.dart';
import 'package:lingua/screens_mobile/home/view_model/home_prov.dart';
import 'package:lingua/utils/api/api_user.dart';
import 'package:lingua/utils/etc/exit_confirm.dart';
import 'package:lingua/utils/file_process/translate_input_process.dart';
import 'package:lingua/widgets/commons/common_divider.dart';
import 'package:lingua/widgets/commons/common_widget.dart';
import 'package:lingua/widgets/read_widgets/call_limit_widget.dart';
import 'package:lingua/widgets/read_widgets/read_button_widget.dart';
import 'package:lingua/widgets/read_widgets/text_field_widget.dart';
import 'package:lingua/widgets/read_widgets/translated_field_widget.dart';
import 'package:lingua/widgets/read_widgets/words_widget.dart';
import 'package:lingua/utils/etc/error_toast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  // handle app lifecycle state change (pause/resume)
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    HomeProv readProv = Provider.of<HomeProv>(globalContext, listen: false);
    switch (state) {
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        if (!readProv.model.STOP_REFRESH) {
          periodicRefresh(email: UserModel.email).then((value) {
            readProv.model.requestQuota.value = value;
          });
        }

        break;

      default:
    }
  }

  @override
  void initState() {

    HomeProv readProv = Provider.of<HomeProv>(navKey.currentContext!, listen: false);
    readProv.model.refreshPeriodSecond =
        readProv.model.refreshPeriodMinute * 60;
    if (!readProv.model.STOP_REFRESH) {
      periodicRefresh(email: UserModel.email).then((value) {
        readProv.model.requestQuota.value = value;
      });
    }

    WidgetsBinding.instance.addObserver(this);
    readProv.model.index = 0;
    readProv.model.futureOption = readProv.initOption();
    readProv.schedulePeriodicTask();
    super.initState();
  }

  @override
  void dispose() {
    HomeProv readProv = Provider.of<HomeProv>(globalContext, listen: false);
    readProv.model.scrollController.dispose();
    readProv.model.scrollTimerController.dispose();
    readProv.model.serverRequestTimer.cancel();
    readProv.model.countdownTimer.cancel();
    readProv.model.requestQuota.dispose();
    readProv.model.machineTranslated.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomeProv readProv = Provider.of<HomeProv>(context);

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
              child: const HomeAppBar(),
            ),
            drawer: const HomeReadDrawer(),
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
                                  showToast('입력칸이 비어 있습니다.');
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
