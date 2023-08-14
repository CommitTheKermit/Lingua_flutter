import 'package:lingua/services/stopword.dart';

mixin SentenceProcess {
  List<String> extractWords(String sentence) {
    List<String> words = sentence.split(RegExp(r"[\n, ]"));
    List<String> outputWords = [];
    String lowercaseWord;
    for (var word in words) {
      word = word.trim().replaceAll(RegExp(r"[^a-zA-Z]"), "");
      lowercaseWord = word.toLowerCase();
      if (!Stopword.stopwords.contains(lowercaseWord) && word != '') {
        outputWords.add(word);
      }
    }

    return outputWords;
  }
}
