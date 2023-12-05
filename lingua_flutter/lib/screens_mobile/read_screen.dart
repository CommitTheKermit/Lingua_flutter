import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/models/read_option.dart';
import 'package:lingua/models/user_model.dart';
import 'package:lingua/screens_mobile/read_mode_screen.dart';
import 'package:lingua/screens_mobile/etc_screens/read_option_screen.dart';
import 'package:lingua/screens_mobile/user_screens/login_screen.dart';
import 'package:lingua/util/api/api_user.dart';

import 'package:lingua/util/api/api_util.dart';
import 'package:lingua/util/etc/change_screen.dart';
import 'package:lingua/util/etc/exit_confirm.dart';
import 'package:lingua/util/etc/file_process.dart';
import 'package:lingua/util/shared_preferences/save_index.dart';
import 'package:lingua/util/string_process/sentence_process.dart';
import 'package:lingua/util/shared_preferences/preference_manager.dart';
import 'package:lingua/widgets/commons/common_text.dart';
import 'package:lingua/widgets/read_widgets/animation_widgets/input_allow_button.dart';
import 'package:lingua/widgets/read_widgets/animation_widgets/translate_allow_button.dart';
import 'package:lingua/widgets/read_widgets/dialog/dialog_context_widget.dart';
import 'package:lingua/widgets/read_widgets/dialog/dialog_line_search.dart';
import 'package:lingua/widgets/read_widgets/dialog/dialog_word_search.dart';
import 'package:lingua/widgets/read_widgets/read_drawer.dart';
import 'package:lingua/widgets/read_widgets/translated_field_widget.dart';
import 'package:lingua/widgets/read_widgets/zetc/error_toast.dart';
import '../widgets/read_widgets/read_button_widget.dart';
import '../widgets/read_widgets/text_field_widget.dart';
import '../widgets/read_widgets/word_button_widget.dart';

class ReadScreen extends StatefulWidget {
  static bool isAllowTranslate = false;
  static bool isAllowInput = true;
  const ReadScreen({super.key});
  static ReadOption topOption =
      ReadOption(25, 1.7, 'Neo', 0xff000000, 0xffffffff);
  static ReadOption midOption =
      ReadOption(25, 1.7, 'Neo', 0xff000000, 0xffffffff);
  static ReadOption botOption =
      ReadOption(25, 1.7, 'Neo', 0xff000000, 0xffffffff);

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen>
    with
        FileProcess,
        SentenceProcess,
        WidgetsBindingObserver,
        SingleTickerProviderStateMixin {
  bool STOP_REFRESH = true;

  String originalSingleSentence = '';
  String translatedSentence = '';
  late int index;
  // final int finalOriginalFlex = 30;
  // final int finalTranslatedFlex = 28;
  // final int finalInputFlex = 16;

  late int originalTextFieldFlex;
  late int translatedTextFieldFlex;
  late int inputFieldFlex;
  late int wordsScrollFlex;
  late int callLimitFlex;
  late int buttonsFlex;

  bool isLoaded = false;
  bool isInitalized = false;
  ApiUtil apiUtil = ApiUtil();
  List<String> words = [];

  final _formKey = GlobalKey<FormState>();
  late Future<String> futureOption;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollTimerController = ScrollController();
  ValueNotifier<String> machineTranslated = ValueNotifier('');
  ValueNotifier<int> requestQuota = ValueNotifier(0);
  ValueNotifier<int> remainingTime = ValueNotifier(0);

  late Timer serverRequestTimer;
  late Timer countdownTimer;
  final int refreshPeriodMinute = 6;
  late final int refreshPeriodSecond;

  Future<String> initOption() async {
    await ReadScreen.topOption.loadOption(key: 'topOption');
    await ReadScreen.midOption.loadOption(key: 'midOption');
    await ReadScreen.botOption.loadOption(key: 'botOption');
    ReadScreen.isAllowTranslate =
        await PreferenceManager.getBoolValue('isAllowTranslate') ?? false;
    ReadScreen.isAllowInput =
        await PreferenceManager.getBoolValue('isAllowInput') ?? true;

    isInitalized = true;
    setState(() {});

    return 'done';
  }

  void _loadInitialIndex() async {
    int loadedIndex = await IndexSaveLoad.loadCurrentIndex();
    isLoaded = true;
    lineChange(shiftAmount: loadedIndex - index);
  }

  void lineChange({required int shiftAmount}) async {
    machineTranslated.value = '';
    _scrollController.jumpTo(0);
    index += shiftAmount;
    IndexSaveLoad.saveCurrentIndex(index);
    originalSingleSentence = FileProcess.originalSentences[index];
    words = extractWords(originalSingleSentence);
    setState(() {});

    if (ReadScreen.isAllowTranslate) {
      String rawString =
          await apiUtil.requestTranslatedText(originalSingleSentence);
      requestQuota.value = requestQuota.value - 1;

      rawString = rawString.replaceAll(r'\n', '\n').replaceAll(r'\t', '\t');
      machineTranslated.value = rawString;
    }
  }

  void buildRefresh() {
    originalTextFieldFlex = 30;
    translatedTextFieldFlex = 25;
    inputFieldFlex = 16;
    wordsScrollFlex = 9;
    callLimitFlex = 6;
    buttonsFlex = 7;
    if (!ReadScreen.isAllowInput && !ReadScreen.isAllowTranslate) {
      originalTextFieldFlex += translatedTextFieldFlex + inputFieldFlex;
    } else if (ReadScreen.isAllowInput && !ReadScreen.isAllowTranslate) {
      originalTextFieldFlex += translatedTextFieldFlex ~/ 2;
      inputFieldFlex += translatedTextFieldFlex ~/ 2;
    } else if (!ReadScreen.isAllowInput && ReadScreen.isAllowTranslate) {
      originalTextFieldFlex += inputFieldFlex ~/ 2;
      translatedTextFieldFlex += inputFieldFlex ~/ 2;
    }
  }

  // handle app lifecycle state change (pause/resume)
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        if (!STOP_REFRESH) {
          ApiUser.periodicRefresh(email: UserModel.email).then((value) {
            requestQuota.value = value;
          });
        }

        break;

      default:
    }
  }

  void schedulePeriodicTask() {
    if (!STOP_REFRESH) {
      DateTime now = DateTime.now();
      DateTime nextRun = now.add(Duration(
          seconds: refreshPeriodSecond -
              now.second -
              (now.minute % refreshPeriodMinute) * 60));

      Duration initialDelay = nextRun.difference(now);
      remainingTime.value = initialDelay.inSeconds;

      countdownTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        setState(() {
          if (remainingTime.value > 0) {
            remainingTime.value--;
          }
        });
      });

      Timer(initialDelay, () {
        ApiUser.periodicRefresh(email: UserModel.email).then((value) {
          requestQuota.value = value;
        });
        remainingTime.value = refreshPeriodSecond;

        serverRequestTimer =
            Timer.periodic(Duration(minutes: refreshPeriodMinute), (Timer t) {
          ApiUser.periodicRefresh(email: UserModel.email).then((value) {
            requestQuota.value = value;
          });
          remainingTime.value = refreshPeriodSecond;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    refreshPeriodSecond = refreshPeriodMinute * 60;
    if (!STOP_REFRESH) {
      ApiUser.periodicRefresh(email: UserModel.email).then((value) {
        requestQuota.value = value;
      });
    }

    WidgetsBinding.instance.addObserver(this);
    index = 0;
    futureOption = initOption();
    schedulePeriodicTask();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _scrollTimerController.dispose();
    serverRequestTimer.cancel();
    countdownTimer.cancel();
    requestQuota.dispose();
    machineTranslated.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    buildRefresh();

    return FutureBuilder(
      future: futureOption,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppLingua.height * 0.06),
              child: readAppBar(context),
            ),
            drawer: readDrawer(context),
            body: WillPopScope(
              onWillPop: () async {
                return exitConfirm(context);
              },
              child: Column(
                children: [
                  commonDivider(context),
                  TextFieldWidget(
                    argText: originalSingleSentence.isNotEmpty
                        ? originalSingleSentence
                        : '원문 출력칸',
                    flexValue: originalTextFieldFlex,
                    readOption: ReadScreen.topOption,
                    currentIndex: isLoaded ? index : 0,
                    endIndex:
                        isLoaded ? FileProcess.originalSentences.length : 0,
                  ),
                  ReadScreen.isAllowTranslate
                      ? commonDivider(context)
                      : const SizedBox.shrink(),
                  ReadScreen.isAllowTranslate
                      ? Flexible(
                          fit: FlexFit.tight,
                          flex: translatedTextFieldFlex,
                          child: ValueListenableBuilder(
                            valueListenable: machineTranslated,
                            builder: (context, value, child) {
                              if (value.isEmpty &&
                                  isLoaded &&
                                  ReadScreen.isAllowTranslate) {
                                return Stack(
                                  children: [
                                    TranslatedFieldWidget(
                                      argText: '로딩 중...',
                                      readOption: ReadScreen.midOption,
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
                                  readOption: ReadScreen.midOption,
                                );
                              }
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                  ReadScreen.isAllowInput
                      ? commonDivider(context)
                      : const SizedBox.shrink(),
                  ReadScreen.isAllowInput
                      ? Flexible(
                          fit: FlexFit.tight,
                          flex: inputFieldFlex,
                          child: Container(
                            width: AppLingua.width,
                            decoration: BoxDecoration(
                              color: Color(
                                  ReadScreen.botOption.optBackgroundColor),
                            ),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: TextFormField(
                                  style: const TextStyle(
                                    fontSize: 23,
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  key: _formKey,
                                  decoration: InputDecoration(
                                      hintText: '번역문 입력칸',
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        fontSize:
                                            ReadScreen.botOption.optFontSize,
                                        height:
                                            ReadScreen.botOption.optFontHeight,
                                        color: Color(
                                            ReadScreen.botOption.optFontColor),
                                        fontFamily:
                                            ReadScreen.botOption.optFontFamily,
                                      )),
                                  validator: (value) {
                                    translatedSentence = value!;
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  commonDivider(context),
                  Flexible(
                    flex: wordsScrollFlex,
                    child: Container(
                      width: AppLingua.width,
                      height: AppLingua.height * 0.08,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: originalSingleSentence.isNotEmpty
                              ? [
                                  for (int i = 0; i < words.length; i++)
                                    WordButtonWidget(
                                      inButtonText: words[i],
                                    ),
                                ]
                              : [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ],
                        ),
                      ),
                    ),
                  ),
                  commonDivider(context),
                  Flexible(
                    flex: callLimitFlex,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _scrollTimerController,
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: AppLingua.width * 2.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: AppLingua.width * 0.8,
                              height: AppLingua.height * 0.05,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: AppLingua.width * 0.05,
                                    ),
                                    child: commonText(
                                      labelText: '번역 제한',
                                      fontColor: const Color(0xFF868E96),
                                      fontSize: AppLingua.height * 0.02,
                                    ),
                                  ),
                                  ValueListenableBuilder(
                                    valueListenable: requestQuota,
                                    builder: (context, value, child) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                        ),
                                        child: commonText(
                                          labelText: "$value/200",
                                          fontWeight: FontWeight.w400,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.0225,
                                          fontColor: const Color(0xFF171A1D),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            VerticalDivider(
                              thickness: 0,
                              color: Colors.transparent,
                              width: AppLingua.width * 0,
                            ),
                            Container(
                              width: AppLingua.width * 1.25,
                              height: AppLingua.height * 0.05,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _scrollTimerController.animateTo(
                                          _scrollTimerController
                                              .position.maxScrollExtent,
                                          duration:
                                              const Duration(milliseconds: 700),
                                          curve: Curves.easeInOut);

                                      Future.delayed(const Duration(seconds: 3),
                                          () {
                                        _scrollTimerController.animateTo(0,
                                            duration: const Duration(
                                                milliseconds: 700),
                                            curve: Curves.easeInOut);
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),
                                      child: Image.asset(
                                        "assets/images/timer.png",
                                        height: AppLingua.height * 0.033,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: AppLingua.width * 0.12,
                                    ),
                                    child: Image.asset(
                                      "assets/images/timer_colored.png",
                                      height: AppLingua.height * 0.033,
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.025),
                                          child: commonText(
                                            labelText: '번역 제한 충전까지',
                                            fontColor: const Color(0xFF868E96),
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05),
                                          child: ValueListenableBuilder(
                                            valueListenable: remainingTime,
                                            builder: (context, value, child) {
                                              String time =
                                                  '${value ~/ 60}:${value % 60}';
                                              return Text(
                                                time,
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          30,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  commonDivider(context),
                  Flexible(
                    flex: buttonsFlex,
                    child: Container(
                      height: double.infinity,
                      width: AppLingua.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ReadButtonWidget(
                              indexLimit: index == 0 && !isLoaded,
                              onTapFunc: index == 0
                                  ? () {}
                                  : () {
                                      lineChange(shiftAmount: -1);
                                    },
                              imageFileOff: 'assets/images/off_prev_button.png',
                              imageFileOn: 'assets/images/on_prev_button.png',
                            ),
                            ReadButtonWidget(
                              indexLimit: index ==
                                      FileProcess.originalSentences.length &&
                                  !isLoaded,
                              onTapFunc:
                                  index == FileProcess.originalSentences.length
                                      ? () {}
                                      : () {
                                          lineChange(
                                            shiftAmount: 1,
                                          );
                                        },
                              imageFileOff: 'assets/images/off_next_button.png',
                              imageFileOn: 'assets/images/on_next_button.png',
                            ),
                            ReadButtonWidget(
                              indexLimit: !isLoaded,
                              onTapFunc: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                } else {
                                  return;
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

  Divider commonDivider(BuildContext context) {
    return Divider(
      color: Colors.transparent,
      thickness: AppLingua.height * 0.005,
      height: AppLingua.height * 0.005,
    );
  }

  ReadDrawer readDrawer(BuildContext context) {
    return ReadDrawer(
      listTiles: [
        ListTile(
          leading: Image.asset(
            'assets/images/icon_file_read.png',
            width: AppLingua.height * 0.03,
          ),
          title: const Text(
            '파일 읽기',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onTap: () async {
            try {
              Navigator.pop(context);
              FileProcess.originalSentences = await filePickAndRead();
              _loadInitialIndex();
            } catch (e) {}
          },
        ),
        ListTile(
          leading: Image.asset(
            'assets/images/icon_read_mode.png',
            width: AppLingua.height * 0.03,
          ),
          title: const Text(
            '읽기 모드',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onTap: isLoaded
              ? () {
                  Navigator.pop(context);
                  changeScreen(
                    context: context,
                    nextScreen: const ReadModeScreen(),
                    isReplace: false,
                  );
                }
              : () {
                  errorToast(argText: '파일을 먼저 불러와주세요.');
                },
        ),
        ListTile(
          leading: Image.asset(
            'assets/images/icon_read_setting.png',
            width: AppLingua.height * 0.03,
          ),
          title: const Text(
            '읽기 옵션',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onTap: () async {
            Navigator.pop(context);
            String? result = await Navigator.push(
              context,
              PageRouteBuilder(
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(0.0, 0.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
                pageBuilder: (context, anmation, secondaryAnimation) =>
                    const ReadOptionScreen(),
              ),
            );
            if (result != null) {
              await initOption();
            }
          },
        ),
        ListTile(
          leading: Image.asset(
            'assets/images/icon_line_change.png',
            width: AppLingua.height * 0.03,
          ),
          title: const Text(
            '줄 이동',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onTap: isLoaded
              ? () {
                  Navigator.pop(context);
                  lineSearchDialog(
                    context: context,
                    argIndex: index,
                  );
                }
              : () {
                  errorToast(argText: '파일을 먼저 불러와주세요.');
                },
        ),
        ListTile(
          leading: Image.asset(
            'assets/images/icon_wordbook.png',
            width: AppLingua.height * 0.03,
          ),
          title: const Text(
            '단어장',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onTap: () {
            errorToast(argText: '준비중.');
          },
        ),
      ],
    );
  }

  Widget readAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      // foregroundColor: const Color(0xFFF8F9FA),
      backgroundColor: Colors.white,
      // backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      shape: const Border(
        left: BorderSide(color: Color(0xFFDEE2E6)),
        top: BorderSide(color: Color(0xFFDEE2E6)),
        right: BorderSide(color: Color(0xFFDEE2E6)),
        bottom: BorderSide(width: 1, color: Color(0xFFDEE2E6)),
      ),

      // No text styles in this selection

      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Image.asset(
              "assets/images/sort_button.png",
              height: AppLingua.height * 0.03,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Drawer를 엽니다.
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      actions: [
        InputAllowButton(
          apiUtil: apiUtil,
          onPressedCallback: () {
            setState(() {});
          },
          assetName: "assets/images/edit_button.png",
          iconSize: AppLingua.height * 0.03,
        ),
        TranslateAllowButton(
          apiUtil: apiUtil,
          onPressedCallback: () {
            setState(() {});
            if (isLoaded) {
              lineChange(shiftAmount: 0);
            }
          },
          assetName: "assets/images/translate_button.png",
          iconSize: AppLingua.height * 0.03,
        ),
        IconButton(
          iconSize: 20,
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return const DialogWordSearch();
              },
            );
          },
          icon: Image.asset(
            "assets/images/search_button.png",
            height: AppLingua.height * 0.03,
          ),
        ),
        IconButton(
          iconSize: 30,
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return DialogContextWidget(index: index);
              },
            );
          },
          icon: const Icon(Icons.menu_book_rounded),
          color: Colors.white,
        ),
      ],
      title: null, // title을 null로 설정
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return FlexibleSpaceBar(
            title: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: AppLingua.width / 2,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: commonText(
                    labelText: FileProcess.titleNovel.isNotEmpty // 파일 제목 출력
                        ? FileProcess.titleNovel
                        : '파일을 선택해주세요.',
                    fontSize: AppLingua.height * 0.025,
                    fontColor: const Color(0xFF1E4A75),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            titlePadding: EdgeInsets.only(
                left: 50, top: AppLingua.height * 0.03), // 원하는 위치로 조절
          );
        },
      ),
    );
  }

  Future<dynamic> lineSearchDialog(
      {required context, required int argIndex}) async {
    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return DialogLineSearch(
          index: argIndex,
        );
      },
    );

    setState(() {
      if (result == 'back') {
        return;
      }
      // index = result;
      // IndexSaveLoad.saveCurrentIndex(index);
      // originalSingleSentence = FileProcess.originalSentences[index];
      // words = extractWords(originalSingleSentence);
      // _scrollController.jumpTo(0);

      lineChange(shiftAmount: result - index);
    });
  }
}
