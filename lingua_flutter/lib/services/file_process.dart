import 'dart:io';

import 'package:file_picker/file_picker.dart';

mixin FileProcess {
  static String titleNovel = "";
  Future<String?> fileRead(String path) async {
    try {
      final file = File(path);
      final pathFrags = file.path.split('/');
      titleNovel = pathFrags[pathFrags.length - 1].split('.')[0];
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      print("Error reading file: $e");
      return null;
    }
  }

  Future<String?> filePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'], // 텍스트 파일만 선택하려면 'txt' 확장자를 사용하세요
    );

    if (result != null) {
      return result.files.single.path;
    } else {
      // 사용자가 선택을 취소한 경우
      return null;
    }
  }

  Future<List<String>> filePickAndRead() async {
    String? filePath = await filePick();
    if (filePath != null) {
      String? contents = await fileRead(filePath);
      if (contents != null) {
        // print(contents);
        // 여기서 파일의 내용에 대한 작업을 수행합니다.String content = file.readAsStringSync();
        List<String> sentences = splitIntoSentences(contents);

        return sentences; // 혹은 다른 작업을 수행합니다.
      }
    }
    throw IOException;
  }

  List<String> splitIntoSentences(String text) {
    // 문장 부호를 기준으로 텍스트를 분리합니다.
    var sentenceEndings = RegExp(r'[.!?]');
    var sentences = <String>[];
    var start = 0;

    for (var match in sentenceEndings.allMatches(text)) {
      var end = match.end;
      var sentence = text.substring(start, end);
      if (sentence.isNotEmpty) {
        sentences.add(sentence.trim());
      }

      start = end;
    }

    return sentences;
  }
}
