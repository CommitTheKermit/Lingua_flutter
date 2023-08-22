import 'package:flutter/material.dart';
import 'package:lingua/services/file_process.dart';
import 'package:lingua/services/sentence_process.dart';
import 'package:lingua/util/double_press_exit.dart';
import 'package:lingua/util/save_index.dart';
import 'package:lingua/widgets/dialog_context_widget.dart';

import '../widgets/read_button_widget.dart';
import '../widgets/text_field_widget.dart';
import '../widgets/word_button_widget.dart';

class ReadScreen extends StatefulWidget {
  const ReadScreen({super.key});

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen>
    with FileProcess, SentenceProcess {
  String originalSingleSentence = "";

  late int index = 0;
  List<String> words = [];

  void _loadInitialIndex() async {
    int loadedIndex = await IndexSaveLoad.loadCurrentIndex();
    setState(() {
      index = loadedIndex;
    });
  }

  @override
  void dispose() {
    IndexSaveLoad.saveCurrentIndex(index);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).textTheme.displayLarge!.color,
        automaticallyImplyLeading: false,
        leading: PopupMenuButton<Text>(
          icon: const Icon(Icons.menu),
          color: Colors.white,
          iconSize: 40,
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () async {
                  FileProcess.originalSentences = await filePickAndRead();
                  setState(() {
                    _loadInitialIndex();
                    originalSingleSentence =
                        FileProcess.originalSentences[index];
                    words = extractWords(originalSingleSentence);
                  });
                },
                child: const Text("파일 읽기"),
              ),
              const PopupMenuItem(
                child: Text(
                  "2",
                ),
              ),
              const PopupMenuItem(
                child: Text(
                  "3",
                ),
              ),
            ];
          },
        ),
        actions: [
          IconButton(
            iconSize: 40,
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
        title: Text(FileProcess.titleNovel.isNotEmpty
            ? FileProcess.titleNovel
            : '파일을 선택해주세요.'),
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
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
              argText: '번역문 입력칸',
              flexValue: 18,
              tempColor: Colors.blue,
            ),
            Flexible(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReadButtonWidget(
                      inButtonText: 'TEMP',
                      onTapFunc: () {},
                    ),
                    ReadButtonWidget(
                      inButtonText: '이전줄',
                      onTapFunc: () {
                        setState(() {
                          index -= 1;

                          originalSingleSentence =
                              FileProcess.originalSentences[index];
                          words = extractWords(originalSingleSentence);
                        });
                      },
                    ),
                    ReadButtonWidget(
                      inButtonText: '다음줄',
                      onTapFunc: () {
                        setState(() {
                          index += 1;
                          originalSingleSentence =
                              FileProcess.originalSentences[index];
                          words = extractWords(originalSingleSentence);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const TextFieldWidget(
              argText: '기계번역문',
              flexValue: 28,
              tempColor: Colors.green,
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
              flex: 9,
              child: SingleChildScrollView(
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
                      : [],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
