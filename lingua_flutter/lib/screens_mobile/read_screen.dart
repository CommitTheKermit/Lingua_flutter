import 'package:flutter/material.dart';
import 'package:lingua/services/file_process.dart';
import 'package:lingua/services/sentence_process.dart';
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
  late List<String> originalSentences = [];
  late int index = 0;
  List<String> words = [];

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
                  originalSentences = await filePickAndRead();
                  setState(() {
                    originalSingleSentence = originalSentences[index];
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
                  List<String> contextSentences = [];
                  int head = 0;
                  int tail = 0;
                  int diff = 10;

                  head = index < 5 ? 0 : (index - (diff ~/ 2));
                  tail = index > originalSentences.length
                      ? originalSentences.length
                      : diff - head + index;
                  for (int i = head; i < tail; i++) {
                    contextSentences.add(originalSentences[index + i]);
                  }
                  return DialogContextWidget(argTextList: contextSentences);
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
      body: Column(
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
            flexValue: 20,
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
                        originalSingleSentence = originalSentences[index];
                        words = extractWords(originalSingleSentence);
                      });
                    },
                  ),
                  ReadButtonWidget(
                    inButtonText: '다음줄',
                    onTapFunc: () {
                      setState(() {
                        index += 1;
                        originalSingleSentence = originalSentences[index];
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
            flexValue: 30,
            tempColor: Colors.green,
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
    );
  }
}
