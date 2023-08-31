import 'package:flutter/material.dart';

import '../../models/word_model.dart';

class DictionaryResultWidget extends StatelessWidget {
  const DictionaryResultWidget({
    super.key,
    required this.wordMeans,
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  final Future<List<WordModel>>? wordMeans;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: wordMeans,
      builder: (context, snapshot) {
        if (wordMeans == null) {
          return const SizedBox.shrink();
        }
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
                          bottom:
                              BorderSide(width: 2, color: Colors.grey.shade200),
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
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Text(
                                      wordMean.meaning,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        height: 1.3,
                                      ),
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
    );
  }
}
