import 'dart:io';

import 'package:lingua/models/server_info.dart';
import 'package:lingua/models/user_model.dart';
import 'package:lingua/models/word_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiUtil {
  // static const String baseUrl = "http://10.0.2.2:8000";
  static const String baseUrl = ServerInfo.baseUrl;
  static const int timeoutSec = ServerInfo.timeoutSec;
  static String API_KEY = '';

  static Future<List<WordModel>> dictSearch(String argText) async {
    List<dynamic> returnValue;
    final url = Uri.parse('$baseUrl/dictionary/word');
    return await http
        .post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'word': argText}),
    )
        .then((response) {
      if (response.statusCode == 200) {
        // 서버가 성공적으로 응답하면 JSON을 파싱합니다.
        returnValue = json.decode(response.body);

        ApiUtil.wordRecord(word: argText);
        return returnValue.map((data) => WordModel.fromJson(data)).toList();
      } else if (response.statusCode == 401) {
        returnValue = json.decode("""[{
        "kor": "",
        "pos": "",
        "meaning": "데이터에 단어가 존재하지 않습니다.",
        "example": "",
        "eng_mean": ""
	}]""");
        return returnValue.map((data) => WordModel.fromJson(data)).toList();
      } else {
        // 서버가 200 이외의 상태 코드로 응답하면 예외를 발생시킵니다.
        returnValue = json.decode("""[{
        "kor": "",
        "pos": "",
        "meaning": "서버 오류",
        "example": "",
        "eng_mean": ""
	}]""");
        return returnValue.map((data) => WordModel.fromJson(data)).toList();
      }
    }).timeout(const Duration(seconds: timeoutSec), onTimeout: () {
      return returnValue = json.decode("""[{
        "kor": "",
        "pos": "",
        "meaning": "서버 오류",
        "example": "",
        "eng_mean": ""
	}]""");
    });
  }

  static Future<bool> wordRecord({required String word}) async {
    final url = Uri.parse('$baseUrl/dictionary/wordbook');

    return await http
        .post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'word': word, 'email': UserModel.email}),
    )
        .then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }).timeout(
      const Duration(seconds: timeoutSec),
      onTimeout: () => false, // 3초 후에 실행될 대체값입니다.
    );
  }

  static Future<bool> sendTranslatedText(String argText) async {
    final url = Uri.parse('$baseUrl/users/mailverify');

    return http
        .post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'word': argText,
        'email': UserModel.email,
      }),
    )
        .then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }).timeout(
      const Duration(seconds: timeoutSec),
      onTimeout: () => false, // 3초 후에 실행될 대체값입니다.
    );
  }

  Future<String> requestTranslatedText(String argText) async {
    String apiKey = API_KEY; // 환경 변수나 별도 설정 파일에서 불러와야 함

    if (Platform.isAndroid) {}
    final url = Uri.parse('https://api-free.deepl.com/v2/translate');

    try {
      final response = await http
          .post(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'DeepL-Auth-Key $apiKey', // 오타 수정
              'User-Agent': 'lingua/1.2.3',
            },
            body: jsonEncode({
              "text": [argText], // 함수 인자로 받은 텍스트
              "source_lang": "EN",
              "target_lang": "KO",
              "preserve_formatting": true,
            }),
          )
          .timeout(
            const Duration(seconds: timeoutSec),
          );

      if (response.statusCode == 200) {
        Map<String, dynamic> result = jsonDecode(response.body);
        String decodedData = utf8.decode(response.bodyBytes);
        int start = decodedData.indexOf('"text":');
        decodedData = decodedData.substring(start + 8, decodedData.length - 4);
        // print(decodedData);
        return decodedData;
      } else {
        return 'error Failed with status code ${response.statusCode}';
      }
    } catch (e) {
      return 'error Request failed with error: $e';
    }
  }

  Future<bool> getApiKey() async {
    final url = Uri.parse('$baseUrl/util/getapikey');

    return await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        ApiUtil.API_KEY = json.decode(response.body)['api_key'];
        return true;
      } else {
        return false;
      }
    }).timeout(
      const Duration(seconds: timeoutSec),
      onTimeout: () => false, // 3초 후에 실행될 대체값입니다.
    );
  }
}
