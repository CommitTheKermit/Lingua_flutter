import 'package:flutter/material.dart';
import 'package:lingua/models/read_option.dart';
import 'package:lingua/screens_mobile/read_mode_screen.dart';
import 'package:lingua/screens_mobile/etc_screens/read_option_screen.dart';

import 'package:lingua/util/api/api_util.dart';
import 'package:lingua/util/change_screen.dart';
import 'package:lingua/util/exit_confirm.dart';
import 'package:lingua/util/file_process.dart';
import 'package:lingua/util/save_index.dart';
import 'package:lingua/util/sentence_process.dart';
import 'package:lingua/widgets/read_widgets/color_change_button_widget.dart';
import 'package:lingua/widgets/read_widgets/dialog/dialog_line_search.dart';
import 'package:lingua/widgets/read_widgets/dialog/dialog_word_search.dart';
import 'package:lingua/widgets/read_widgets/read_drawer.dart';
import 'package:lingua/widgets/read_widgets/translated_field_widget.dart';
import 'package:lingua/widgets/read_widgets/zetc/error_toast.dart';
import '../widgets/read_widgets/dialog/dialog_context_widget.dart';
import '../widgets/read_widgets/read_button_widget.dart';
import '../widgets/read_widgets/text_field_widget.dart';
import '../widgets/read_widgets/word_button_widget.dart';

class ReadScreen extends StatefulWidget {
  static bool isAllowTranslate = false;
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
    with FileProcess, SentenceProcess {
  String originalSingleSentence = "";
  late int index;
  List<String> words = [];
  bool isLoaded = false;
  final _formKey = GlobalKey<FormState>();
  String translatedSentence = '';

  late Future<String> futureOption;
  bool isInitalized = false;
  ApiUtil apiUtil = ApiUtil();

  final ScrollController _scrollController = ScrollController();

  ValueNotifier<String> machineTranslated = ValueNotifier('');

  Future<String> initOption() async {
    await ReadScreen.topOption.loadOption(key: 'topOption');
    await ReadScreen.midOption.loadOption(key: 'midOption');
    await ReadScreen.botOption.loadOption(key: 'botOption');
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
      rawString = rawString.replaceAll(r'\n', '\n').replaceAll(r'\t', '\t');
      machineTranslated.value = rawString;
    }
  }

  @override
  void initState() {
    index = 0;
    super.initState();
    futureOption = initOption();
  }

  @override
  Widget build(BuildContext context) {
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
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).size.height * 0.06),
              child: readAppBar(context),
            ),
            drawer: readDrawer(context),
            body: WillPopScope(
              onWillPop: () async {
                return exitConfirm(context);
              },
              child: Column(
                children: [
                  TextFieldWidget(
                    argText: originalSingleSentence.isNotEmpty
                        ? originalSingleSentence
                        : '원문 출력칸',
                    flexValue: 30,
                    readOption: ReadScreen.topOption,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 23,
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
                                  constraints: const BoxConstraints.expand(),
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
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 23,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color(ReadScreen.botOption.optBackgroundColor),
                        border: Border(
                          bottom: BorderSide(
                            width: 2,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ),
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
                                  fontSize: ReadScreen.botOption.optFontSize,
                                  height: ReadScreen.botOption.optFontHeight,
                                  color:
                                      Color(ReadScreen.botOption.optFontColor),
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
                  ),
                  Flexible(
                    flex: 9,
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
                  Flexible(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '기계번역콜제한',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 30,
                          ),
                        ),
                        Text(
                          '$index/${FileProcess.originalSentences.length}',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height / 30,
                          ),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReadButtonWidget(
                            indexLimit: index == 0,
                            inButtonText: '이전줄',
                            onTapFunc: index == 0
                                ? () {}
                                : () {
                                    lineChange(shiftAmount: -1);
                                  },
                          ),
                          ReadButtonWidget(
                            indexLimit: !isLoaded,
                            inButtonText: '입력',
                            onTapFunc: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                              } else {
                                return;
                              }
                            },
                          ),
                          ReadButtonWidget(
                            indexLimit:
                                index == FileProcess.originalSentences.length,
                            inButtonText: '다음줄',
                            onTapFunc:
                                index == FileProcess.originalSentences.length
                                    ? () {}
                                    : () {
                                        lineChange(
                                          shiftAmount: 1,
                                        );
                                      },
                          ),
                        ],
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
            } catch (e) {
              Navigator.pop(context);
              changeScreen(
                context: context,
                nextScreen: const ReadScreen(),
                isReplace: false,
              );
            }
          },
        ),
        ListTile(
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

  AppBar readAppBar(BuildContext context) {
    return AppBar(
      elevation: 1,
      foregroundColor: Colors.white,
      backgroundColor: Theme.of(context).primaryColor,
      automaticallyImplyLeading: false,

      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Drawer를 엽니다.
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),

      actions: [
        ColorChangeButtonWidget(
          apiUtil: apiUtil,
        ),
        IconButton(
          iconSize: 30,
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return const DialogWordSearch();
              },
            );
          },
          icon: const Icon(Icons.search_sharp),
          color: Colors.white,
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
              child: Text(
                FileProcess.titleNovel.isNotEmpty // 파일 제목 출력
                    ? FileProcess.titleNovel
                    : '파일을 선택해주세요.',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.03,
                  color: Colors.white,
                ),
              ),
            ),
            titlePadding: EdgeInsets.only(
                left: 50,
                top: MediaQuery.of(context).size.height * 0.03), // 원하는 위치로 조절
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
