import 'package:flutter/material.dart';
import 'package:lingua/screens_mobile/read_mode_screen.dart';
import 'package:lingua/services/file_process.dart';
import 'package:lingua/services/sentence_process.dart';
import 'package:lingua/util/change_screen.dart';
import 'package:lingua/util/exit_confirm.dart';
import 'package:lingua/util/save_index.dart';
import 'package:lingua/widgets/read_widgets/color_change_button_widget.dart';
import 'package:lingua/widgets/read_widgets/dialog_line_search.dart';
import 'package:lingua/widgets/read_widgets/read_drawer.dart';

import '../widgets/read_widgets/dialog_context_widget.dart';
import '../widgets/read_widgets/dialog_word_search.dart';
import '../widgets/read_widgets/read_button_widget.dart';
import '../widgets/read_widgets/text_field_widget.dart';
import '../widgets/read_widgets/word_button_widget.dart';

class ReadScreen extends StatefulWidget {
  const ReadScreen({super.key});

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
  bool isMachineTranslate = false;

  final ScrollController _scrollController = ScrollController();

  void _loadInitialIndex() async {
    int loadedIndex = await IndexSaveLoad.loadCurrentIndex();
    index = loadedIndex;
    originalSingleSentence = FileProcess.originalSentences[index];
    words = extractWords(originalSingleSentence);
    isLoaded = true;
    setState(() {});
  }

  @override
  void initState() {
    index = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
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
            GestureDetector(
              onTap: () => isMachineTranslate = !isMachineTranslate,
              child: const ColorChangeButtonWidget(),
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
                title: Text(
                  FileProcess.titleNovel.isNotEmpty // 파일 제목 출력
                      ? FileProcess.titleNovel
                      : '파일을 선택해주세요.',
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                titlePadding:
                    const EdgeInsets.only(left: 50, bottom: 10), // 원하는 위치로 조절
              );
            },
          ),
        ),
      ),
      drawer: ReadDrawer(
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
                FileProcess.originalSentences = await filePickAndRead();
                _loadInitialIndex();
              } catch (e) {
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
                    changeScreen(
                      context: context,
                      nextScreen: const ReadModeScreen(),
                      isReplace: false,
                    );
                  }
                : () {},
          ),
          ListTile(
            title: const Text(
              '읽기 옵션',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
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
                      lineSearchDialog(
                        context: context,
                        index: index,
                      );
                    }
                  : () {}),
        ],
      ),
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
              tempColor: Colors.white,
            ),
            const TextFieldWidget(
              argText: '기계번역문',
              flexValue: 23,
              tempColor: Colors.green,
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 23,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
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
                      decoration: const InputDecoration(
                          hintText: '번역문 입력칸',
                          border: InputBorder.none,
                          hintStyle: TextStyle(fontSize: 25)),
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
                              color: Colors.white,
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
                  const Text(
                    '기계번역콜제한',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    '$index/${FileProcess.originalSentences.length}',
                    style: const TextStyle(
                      fontSize: 25,
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
                              setState(() {
                                index -= 1;
                                IndexSaveLoad.saveCurrentIndex(index);
                                originalSingleSentence =
                                    FileProcess.originalSentences[index];
                                words = extractWords(originalSingleSentence);
                                _scrollController.jumpTo(0);
                              });
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
                      indexLimit: index == FileProcess.originalSentences.length,
                      inButtonText: '다음줄',
                      onTapFunc: index == FileProcess.originalSentences.length
                          ? () {}
                          : () {
                              setState(() {
                                index += 1;
                                IndexSaveLoad.saveCurrentIndex(index);
                                originalSingleSentence =
                                    FileProcess.originalSentences[index];
                                words = extractWords(originalSingleSentence);
                                _scrollController.jumpTo(0);
                              });
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

  Future<dynamic> lineSearchDialog(
      {required context, required int index}) async {
    final result = showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return DialogLineSearch(
          index: index,
        );
      },
    );
  }
}
