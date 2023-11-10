import 'package:flutter/material.dart';
import 'package:lingua/util/file_process.dart';

enum PageState {
  prev,
  current,
  next,
}

class DialogContextWidget extends StatefulWidget {
  final int index;

  const DialogContextWidget({
    super.key,
    required this.index,
  });

  @override
  State<DialogContextWidget> createState() => _DialogContextWidgetState();
}

class _DialogContextWidgetState extends State<DialogContextWidget> {
  final ScrollController _scrollController = ScrollController();
  late List<String> argTextList;
  late int head;
  late int tail;

  List<String> contextChange(PageState pageAction) {
    List<String> contextSentences = [];
    int diff = 10;

    switch (pageAction) {
      case PageState.prev:
        {
          tail = head;
          head = tail - diff;
          break;
        }
      case PageState.next:
        {
          head = tail;
          tail = head + diff;
          break;
        }
      case PageState.current:
        {
          head = widget.index;
          tail = head + diff;
          break;
        }
    }

    head = head < 0 ? 0 : head;
    tail = tail > FileProcess.originalSentences.length
        ? FileProcess.originalSentences.length
        : tail;
    for (int i = head; i < tail; i++) {
      contextSentences.add(FileProcess.originalSentences[widget.index + i]);
    }
    return contextSentences;
  }

  @override
  void initState() {
    super.initState();
    argTextList = contextChange(PageState.current);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    argTextList = contextChange(PageState.prev);
                    _scrollController.jumpTo(0);
                    setState(() {});
                  },
                  child: Text(
                    '이전',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.displayLarge!.color),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    argTextList = contextChange(PageState.next);
                    _scrollController.jumpTo(0);
                    setState(() {});
                  },
                  child: Text(
                    '다음',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.displayLarge!.color),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '닫기',
                style: TextStyle(
                    color: Theme.of(context).textTheme.displayLarge!.color),
              ),
            ),
          ],
        )
      ],
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      title: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Center(
          child: Text(
            FileProcess.titleNovel,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      content: Container(
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              width: 2,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              for (int i = 0; i < argTextList.length; i++)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (head + i).toString(),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 19),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 70,
                        child: Text(
                          argTextList[i],
                          style: const TextStyle(fontSize: 25),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  TextButton dialogButton(BuildContext context, String argText, Color color) {
    return TextButton(
      child: Text(
        argText,
        style: TextStyle(
          fontSize: 20,
          color: Theme.of(context).primaryColor,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
