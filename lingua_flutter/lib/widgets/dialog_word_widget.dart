import 'package:flutter/material.dart';
import 'package:lingua/models/word_model.dart';
import 'package:lingua/services/api/api_service.dart';

class DialogWordWidget extends StatefulWidget {
  final String argText;
  const DialogWordWidget({
    super.key,
    required this.argText,
  });

  @override
  State<DialogWordWidget> createState() => _DialogWordWidgetState();
}

class _DialogWordWidgetState extends State<DialogWordWidget> {
  final ScrollController _scrollController = ScrollController();
  late Future<List<WordModel>> wordMeans;

  @override
  void initState() {
    super.initState();
    wordMeans = ApiService.dictSearch(widget.argText);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     dialogButton(
            //       context,
            //       '이전',
            //       Theme.of(context).cardColor,
            //     ),
            //     dialogButton(
            //       context,
            //       '다음',
            //       Theme.of(context).cardColor,
            //     ),
            //   ],
            // ),
            dialogButton(
              context,
              '닫기',
              Theme.of(context).cardColor,
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
            widget.argText,
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
              color: Theme.of(context).cardColor,
            ),
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder(
          future: wordMeans,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.hasData) {
              return SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    for (var wordMean in snapshot.data!)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            border: BorderDirectional(
                              bottom: BorderSide(
                                  width: 2, color: Colors.grey.shade200),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      wordMean.kor,
                                      style: const TextStyle(fontSize: 25),
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Text(
                                      wordMean.pos,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Center(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: Text(
                                          wordMean.meaning,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
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
          color: Theme.of(context).cardColor,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
