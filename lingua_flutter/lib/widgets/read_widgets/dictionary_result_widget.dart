import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lingua/widgets/commons/common.dart';
import 'package:lingua/widgets/commons/common_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
        if (snapshot.connectionState != ConnectionState.done) {
          return comnLoading();
        } else {
          List<WordModel> words = snapshot.data!;

          for (int i = 0; i < words.length; i++) {
            for (int j = 0; j < words.length; j++) {
              if (words[i] == words[j]) {
                continue;
              }
              if (words[i].kor == words[j].kor) {
                if (words[i].meaning != words[j].meaning) {
                  words[i].meaning += words[j].meaning;
                }

                comnLog(words[i].meaning);
                words.remove(words[j]);
                j = 0;
              }
            }

            if (words[i].meaning.indexOf('.') != words[i].meaning.lastIndexOf('.')) {
              List spliited = words[i].meaning.split('.');
              String resultMeaning = '';
              for (int k = 0; k < spliited.length - 1; k++) {
                resultMeaning += k != spliited.length - 2
                    ? '${k + 1}. ${spliited[k]}\n'
                    : '${k + 1}. ${spliited[k]}';
              }

              words[i].meaning = resultMeaning;
            }

            //   resultWords.add(words[i]);
            // } else {
            //   resultWords.add(words[i]);
            // }
          }

          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                for (var wordMean in words)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      width: 90.w,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: Color(0xFFDEE2E6)),
                          borderRadius: BorderRadius.circular(5),
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
                                  style: TextStyle(
                                    color: const Color(0xFF171A1D),
                                    fontSize: 2.5.h,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  width: 1.h,
                                ),
                                wordMean.pos.isNotEmpty
                                    ? Container(
                                        height: 2.5.h,
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFF43698F),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(999),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 2.w,
                                          ),
                                          child: Center(
                                            child: Text(
                                              wordMean.pos,
                                              // wordMean.pos.contains(',')
                                              //     ? wordMean.pos.substring(0,
                                              //         wordMean.pos.indexOf(','))
                                              //     : wordMean.pos,
                                              style: TextStyle(
                                                color: const Color(0xFFF8F9FA),
                                                fontSize:
                                                    MediaQuery.of(context).size.height * 0.0175,
                                                fontWeight: FontWeight.w400,
                                                height:
                                                    MediaQuery.of(context).size.height * 0.00135,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                            Row(
                              children: [
                                Center(
                                  child: SizedBox(
                                    width: 80.w,
                                    child: Text(
                                      wordMean.meaning,
                                      style: TextStyle(
                                        color: const Color(0xFF495057),
                                        fontSize: 2.25.h,
                                        height: 2,
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
      },
    );
  }
}
