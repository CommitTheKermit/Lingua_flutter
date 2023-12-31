import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/models/read_option.dart';
import 'package:lingua/models/user_model.dart';
import 'package:lingua/screens_mobile/main_screens/read_mode_screen.dart';

import 'package:lingua/screens_mobile/etc_screens/read_option_screen.dart';
import 'package:lingua/util/api/api_user.dart';
import 'package:lingua/util/api/api_util.dart';
import 'package:lingua/util/etc/change_screen.dart';
import 'package:lingua/util/etc/exit_confirm.dart';
import 'package:lingua/util/file_process/file_process.dart';
import 'package:lingua/util/file_process/translate_input_process.dart';
import 'package:lingua/util/shared_preferences/save_index.dart';
import 'package:lingua/util/string_process/sentence_process.dart';
import 'package:lingua/util/shared_preferences/preference_manager.dart';
import 'package:lingua/widgets/commons/common_divider.dart';
import 'package:lingua/widgets/commons/common_text.dart';
import 'package:lingua/widgets/read_widgets/animation_widgets/input_allow_button.dart';
import 'package:lingua/widgets/read_widgets/animation_widgets/translate_allow_button.dart';
import 'package:lingua/widgets/read_widgets/call_limit_widget.dart';
import 'package:lingua/widgets/read_widgets/dialog/dialog_line_search.dart';
import 'package:lingua/widgets/read_widgets/dialog/dialog_word_search.dart';
import 'package:lingua/widgets/read_widgets/read_button_widget.dart';
import 'package:lingua/widgets/read_widgets/read_drawer.dart';
import 'package:lingua/widgets/read_widgets/text_field_widget.dart';
import 'package:lingua/widgets/read_widgets/translated_field_widget.dart';
import 'package:lingua/widgets/read_widgets/words_widget.dart';
import 'package:lingua/util/etc/error_toast.dart';

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
  static ReadOption readModeOption =
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
  bool STOP_REFRESH = false;

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

  bool isNovelLoaded = false;
  bool isInitalized = false;
  ApiUtil apiUtil = ApiUtil();
  List<String> words = [];

  final _formKey = GlobalKey<FormState>();
  late Future<String> futureOption;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollTimerController = ScrollController();
  final TextEditingController _inputController = TextEditingController();
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

    if (ReadScreen.isAllowTranslate) {
      ApiUtil apiUtil = ApiUtil();
      apiUtil.getApiKey();
    }
    ReadScreen.isAllowInput =
        await PreferenceManager.getBoolValue('isAllowInput') ?? true;

    isInitalized = true;
    setState(() {});

    return 'done';
  }

  void _loadInitialIndex() async {
    int loadedIndex = await IndexSaveLoad.loadCurrentIndex();
    isNovelLoaded = true;
    lineShift(shiftAmount: loadedIndex - index);
  }

  void lineShift({required int shiftAmount}) async {
    machineTranslated.value = '';
    _scrollController.jumpTo(0);
    index += shiftAmount;
    IndexSaveLoad.saveCurrentIndex(index);
    originalSingleSentence = AppLingua.originalSentences[index];
    words = extractWords(originalSingleSentence);

    //입력 기록 불러오기
    if (AppLingua.inputJson.containsKey(originalSingleSentence)) {
      _inputController.text = AppLingua.inputJson[originalSingleSentence]!;
    } else {
      _inputController.text = '';
    }
    setState(() {});
    if (ReadScreen.isAllowTranslate && requestQuota.value > 0) {
      //번역 기록 불러오기
      if (AppLingua.trasJson.containsKey(originalSingleSentence)) {
        machineTranslated.value = AppLingua.trasJson[originalSingleSentence]!;
        return;
      }

      String translatedString =
          await apiUtil.requestTranslatedText(originalSingleSentence);
      requestQuota.value = requestQuota.value - 1;

      translatedString =
          translatedString.replaceAll(r'\n', '\n').replaceAll(r'\t', '\t');

      //번역 기록 입력
      if (!translatedString.startsWith('error')) {
        AppLingua.trasJson[originalSingleSentence] = translatedString;
        saveMapToFile(
            map: AppLingua.trasJson,
            filename: '${AppLingua.titleNovel}_translated.json');
      }

      machineTranslated.value = translatedString;
    } else if (requestQuota.value <= 0) {
      machineTranslated.value = '번역 콜이 부족합니다.';
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
                  commonDivider(),
                  TextFieldWidget(
                    argText: originalSingleSentence.isNotEmpty
                        ? originalSingleSentence
                        : '원문 출력칸',
                    flexValue: originalTextFieldFlex,
                    readOption: ReadScreen.topOption,
                    currentIndex: isNovelLoaded ? index : 0,
                    endIndex:
                        isNovelLoaded ? AppLingua.originalSentences.length : 0,
                  ),
                  ReadScreen.isAllowTranslate
                      ? commonDivider()
                      : const SizedBox.shrink(),
                  ReadScreen.isAllowTranslate
                      ? Flexible(
                          fit: FlexFit.tight,
                          flex: translatedTextFieldFlex,
                          child: ValueListenableBuilder(
                            valueListenable: machineTranslated,
                            builder: (context, value, child) {
                              if (value.isEmpty &&
                                  isNovelLoaded &&
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
                      ? commonDivider()
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
                                  controller: _inputController,
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
                  commonDivider(),
                  wordsWidget(
                    wordsScrollFlex: wordsScrollFlex,
                    words: words,
                    scrollController: _scrollController,
                    originalSingleSentence: originalSingleSentence,
                  ),
                  commonDivider(),
                  callLimitWidget(
                      callLimitFlex: callLimitFlex,
                      scrollTimerController: _scrollTimerController,
                      requestQuota: requestQuota,
                      remainingTime: remainingTime),
                  commonDivider(),
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
                              indexLimit: index == 0 && !isNovelLoaded,
                              onTapFunc: index == 0
                                  ? () {}
                                  : () {
                                      lineShift(shiftAmount: -1);
                                    },
                              imageFileOff: 'assets/images/off_prev_button.png',
                              imageFileOn: 'assets/images/on_prev_button.png',
                            ),
                            ReadButtonWidget(
                              indexLimit:
                                  index == AppLingua.originalSentences.length &&
                                      !isNovelLoaded,
                              onTapFunc:
                                  index == AppLingua.originalSentences.length
                                      ? () {}
                                      : () {
                                          lineShift(
                                            shiftAmount: 1,
                                          );
                                        },
                              imageFileOff: 'assets/images/off_next_button.png',
                              imageFileOn: 'assets/images/on_next_button.png',
                            ),
                            ReadButtonWidget(
                              indexLimit: !isNovelLoaded,
                              onTapFunc: () {
                                if (_inputController.text.isNotEmpty) {
                                  AppLingua.inputJson[originalSingleSentence] =
                                      _inputController.text;
                                  saveMapToFile(
                                      map: AppLingua.inputJson,
                                      filename:
                                          '${AppLingua.titleNovel}_input.json');
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
              errorToast(argText: '.txt 파일만 불러올 수 있습니다.');
              Navigator.pop(context);
              AppLingua.originalSentences = await filePickAndRead();
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
            '뷰어 모드',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onTap: isNovelLoaded
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
            '옵션',
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
                    const ReadOptionScreen(
                  startingTab: 0,
                ),
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
          onTap: isNovelLoaded
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
            'assets/images/icon_download.png',
            width: AppLingua.height * 0.03,
          ),
          title: const Text(
            '기록 추출',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          onTap: () async {
            await saveFile(fileName: 'fileName');
            errorToast(argText: '저장 완료. 다운로드 폴더를 확인해보세요!');
          },
        ),
        // ListTile(
        //   leading: Image.asset(
        //     'assets/images/icon_wordbook.png',
        //     width: AppLingua.height * 0.03,
        //   ),
        //   title: const Text(
        //     '단어장',
        //     style: TextStyle(
        //       fontSize: 16,
        //     ),
        //   ),
        //   onTap: () {
        //     errorToast(argText: '준비중.');
        //   },
        // ),
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
        bottom: BorderSide(width: 1, color: Color(0xFFDEE2E6)),
      ),

      // No text styles in this selection

      actions: [
        SizedBox(
          width: AppLingua.width,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: AppLingua.width * 0.01),
                child: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: Image.asset(
                        "assets/images/sort_button.png",
                        height: AppLingua.height * 0.03,
                        width: AppLingua.height * 0.03,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer(); // Drawer를 엽니다.
                      },
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip,
                    );
                  },
                ),
              ),
              SizedBox(
                width: AppLingua.width * 0.4,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: commonText(
                    labelText: AppLingua.titleNovel.isNotEmpty // 파일 제목 출력
                        ? AppLingua.titleNovel
                        : '파일을 선택해주세요.',
                    fontSize: AppLingua.height * 0.025,
                    fontColor: const Color(0xFF1E4A75),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                child: Row(
                  children: [
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
                        if (isNovelLoaded) {
                          lineShift(shiftAmount: 0);
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
                  ],
                ),
              ),
            ],
          ),
        ),

        // 문맥 탐색 대화상자
        // IconButton(
        //   iconSize: 30,
        //   onPressed: () {
        //     showDialog(
        //       context: context,
        //       barrierDismissible: true,
        //       builder: (context) {
        //         return DialogContextWidget(index: index);
        //       },
        //     );
        //   },
        //   icon: const Icon(Icons.menu_book_rounded),
        //   color: Colors.white,
        // ),
      ],

      // title을 null로 설정
      // flexibleSpace: LayoutBuilder(
      //   builder: (BuildContext context, BoxConstraints constraints) {
      //     return FlexibleSpaceBar(
      //       title: SizedBox(
      //         width: AppLingua.width / 2,
      //         child: SingleChildScrollView(
      //           scrollDirection: Axis.horizontal,
      //           child: commonText(
      //             labelText: AppLingua.titleNovel.isNotEmpty // 파일 제목 출력
      //                 ? AppLingua.titleNovel
      //                 : '파일을 선택해주세요.',
      //             fontSize: AppLingua.height * 0.025,
      //             fontColor: const Color(0xFF1E4A75),
      //           ),
      //         ),
      //       ),
      //       titlePadding: EdgeInsets.only(
      //           left: 50, top: AppLingua.height * 0.03), // 원하는 위치로 조절
      //     );
      //   },
      // ),
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
      // originalSingleSentence = AppLingua.originalSentences[index];
      // words = extractWords(originalSingleSentence);
      // _scrollController.jumpTo(0);

      lineShift(shiftAmount: result - index);
    });
  }
}
