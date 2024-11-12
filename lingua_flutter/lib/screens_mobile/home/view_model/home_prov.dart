import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/models/user_model.dart';
import 'package:lingua/models/word_model.dart';
import 'package:lingua/screens_mobile/home/model/read_model.dart';
import 'package:lingua/utils/api/api_user.dart';
import 'package:lingua/utils/api/api_util.dart';
import 'package:lingua/utils/api_util.dart';
import 'package:lingua/utils/file_process/translate_input_process.dart';
import 'package:lingua/utils/shared_preferences/preferences.dart';
import 'package:lingua/utils/shared_preferences/save_index.dart';
import 'package:lingua/utils/string_process/sentence_process.dart';
import 'package:lingua/utils/uitl.dart';
import 'package:lingua/widgets/read_widgets/dialog/dialog_line_search.dart';

class HomeProv extends ChangeNotifier {
  HomeModel model = HomeModel();

  void clear() {
    model = HomeModel();
  }

  void notify() {
    notifyListeners();
  }

  Future<String> initOption() async {
    await model.topOption.loadOption(key: 'topOption');
    await model.midOption.loadOption(key: 'midOption');
    await model.botOption.loadOption(key: 'botOption');

    model.isAllowTranslate = getPrefBool('isAllowTranslate') ?? false;

    if (model.isAllowTranslate) {
      // getApiKey();
    }
    model.isAllowInput = getPrefBool('isAllowInput') ?? true;

    model.isInitalized = true;
    notify();

    return 'done';
  }

  void loadInitialIndex() async {
    int loadedIndex = await loadCurrentIndex();
    model.isNovelLoaded = true;
    lineShift(shiftAmount: loadedIndex - model.index);
  }

  void lineShift({required int shiftAmount}) async {
    model.machineTranslated.value = '';
    model.scrollController.jumpTo(0);
    model.index += shiftAmount;
    saveCurrentIndex(model.index);
    model.originalSingleSentence = originalSentences[model.index];
    model.words = extractWords(model.originalSingleSentence);

    //입력 기록 불러오기
    if (inputJson.containsKey(model.originalSingleSentence)) {
      model.inputController.text = inputJson[model.originalSingleSentence]!;
    } else {
      model.inputController.text = '';
    }
    notify();
    if (model.isAllowTranslate && model.requestQuota.value > 0) {
      //번역 기록 불러오기
      if (trasJson.containsKey(model.originalSingleSentence)) {
        model.machineTranslated.value = trasJson[model.originalSingleSentence]!;
        return;
      }

      String translatedString =
          await requestTranslatedText(model.originalSingleSentence);
      model.requestQuota.value = model.requestQuota.value - 1;

      translatedString =
          translatedString.replaceAll(r'\n', '\n').replaceAll(r'\t', '\t');

      //번역 기록 입력
      if (!translatedString.startsWith('error')) {
        trasJson[model.originalSingleSentence] = translatedString;
        saveMapToFile(map: trasJson, filename: '${titleNovel}_translated.json');
      }

      model.machineTranslated.value = translatedString;
    } else if (model.requestQuota.value <= 0) {
      model.machineTranslated.value = '번역 콜이 부족합니다.';
    }
  }

  void buildRefresh() {
    model.originalTextFieldFlex = 30;
    model.translatedTextFieldFlex = 25;
    model.inputFieldFlex = 16;
    model.wordsScrollFlex = 9;
    model.callLimitFlex = 6;
    model.buttonsFlex = 7;
    if (!model.isAllowInput && !model.isAllowTranslate) {
      model.originalTextFieldFlex +=
          model.translatedTextFieldFlex + model.inputFieldFlex;
    } else if (model.isAllowInput && !model.isAllowTranslate) {
      model.originalTextFieldFlex += model.translatedTextFieldFlex ~/ 2;
      model.inputFieldFlex += model.translatedTextFieldFlex ~/ 2;
    } else if (!model.isAllowInput && model.isAllowTranslate) {
      model.originalTextFieldFlex += model.inputFieldFlex ~/ 2;
      model.translatedTextFieldFlex += model.inputFieldFlex ~/ 2;
    }
  }

  void schedulePeriodicTask() {
    if (!model.STOP_REFRESH) {
      DateTime now = DateTime.now();
      DateTime nextRun = now.add(Duration(
          seconds: model.refreshPeriodSecond -
              now.second -
              (now.minute % model.refreshPeriodMinute) * 60));

      Duration initialDelay = nextRun.difference(now);
      model.remainingTime.value = initialDelay.inSeconds;

      model.countdownTimer =
          Timer.periodic(const Duration(seconds: 1), (Timer t) {
        if (model.remainingTime.value > 0) {
          model.remainingTime.value--;
        }
        notify();
      });

      Timer(initialDelay, () {
        periodicRefresh(email: UserModel.email).then((value) {
          model.requestQuota.value = value;
        });
        model.remainingTime.value = model.refreshPeriodSecond;

        model.serverRequestTimer = Timer.periodic(
            Duration(minutes: model.refreshPeriodMinute), (Timer t) {
          periodicRefresh(email: UserModel.email).then((value) {
            model.requestQuota.value = value;
          });
          model.remainingTime.value = model.refreshPeriodSecond;
        });
      });
    }
  }

  Future<dynamic> lineSearchDialog(
      {required context, required int argIndex}) async {
    final result = await comnShowDialog(
        dialog: DialogLineSearch(
      index: argIndex,
    ));

    if (result == 'back') {
      return;
    }
    // index = result;
    // IndexSaveLoad.saveCurrentIndex(index);
    // originalSingleSentence = originalSentences[index];
    // words = extractWords(originalSingleSentence);
    // _scrollController.jumpTo(0);

    lineShift(shiftAmount: result - model.index);
    notify();
  }

  Future<List<WordModel>> dictSearch(String argText) async {
    List<dynamic> returnValue;
    try {
      Map result = await apiPost(
        uri: '/dictionary/word',
        body: {
          'word': argText,
        },
      );
      if (result['statusCode'] == 200) {
        // 서버가 성공적으로 응답하면 JSON을 파싱합니다.
        returnValue = [result];

        // wordRecord(word: argText);
        return returnValue.map((data) => WordModel.fromJson(data)).toList();
      } else if (result['statusCode'] == 401) {
        returnValue = [
          {
            "kor": "",
            "pos": "",
            "meaning": "데이터에 단어가 존재하지 않습니다.",
            "example": "",
            "eng_mean": ""
          },
        ];
        return returnValue.map((data) => WordModel.fromJson(data)).toList();
      } else {
        // 서버가 200 이외의 상태 코드로 응답하면 예외를 발생시킵니다.
        returnValue = [
          {
            "kor": "",
            "pos": "",
            "meaning": "서버 오류",
            "example": "",
            "eng_mean": ""
          },
        ];
        return returnValue.map((data) => WordModel.fromJson(data)).toList();
      }
    } catch (e, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: e,
        stack: stackTrace,
      ));
    }
    return [];
  }
  Future<String> requestTranslatedText(String argText) async {
    String apiKey = API_KEY; // 환경 변수나 별도 설정 파일에서 불러와야 함

    if (Platform.isAndroid) {}
    const deeplUrl = 'https://api-free.deepl.com/v2/translate';
    Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 20), // 연결 타임아웃 10초
        receiveTimeout: const Duration(seconds: 20), // 데이터 수신 타임아웃 10초
      ),
    );
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'DeepL-Auth-Key $apiKey', // 오타 수정
      // 'User-Agent': 'lingua/1.2.3',
    };
    try {
      Response response = await dio.post(
        deeplUrl,
        data:  jsonEncode({
          "text": [argText], // 함수 인자로 받은 텍스트
          "source_lang": "EN",
          "target_lang": "KO",
          "preserve_formatting": true,
        }),
      );

      if (response.statusCode == 200) {

        // String decodedData = utf8.decode(response.bodyBytes);
        // int start = decodedData.indexOf('"text":');
        // decodedData = decodedData.substring(start + 8, decodedData.length - 4);
        // // print(decodedData);
        // return decodedData;
        return (response.data['translations'] as List).first['text'];
      } else {
        return 'error Failed with status code ${response.statusCode}';
      }
    } catch (e) {
      return 'error Request failed with error: $e';
    }
  }
}
