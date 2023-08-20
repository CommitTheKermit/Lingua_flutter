import 'package:lingua/models/word_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000";

  static Future<List<WordModel>> dictSearch(String argText) async {
    final url = Uri.parse('$baseUrl/dictionary/word/');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'word': argText}),
    );

    if (response.statusCode == 200) {
      // 서버가 성공적으로 응답하면 JSON을 파싱합니다.
      final List<dynamic> returnValue = json.decode(response.body);
      return returnValue.map((data) => WordModel.fromJson(data)).toList();
    } else if (response.statusCode == 401) {
      final List<dynamic> returnValue = json.decode("""[{
        "kor": "",
        "pos": "",
        "meaning": "데이터에 단어가 존재하지 않습니다.",
        "example": "",
        "eng_mean": ""
	}]""");
      return returnValue.map((data) => WordModel.fromJson(data)).toList();
    } else {
      // 서버가 200 이외의 상태 코드로 응답하면 예외를 발생시킵니다.
      final List<dynamic> returnValue = json.decode("""[{
        "kor": "",
        "pos": "",
        "meaning": "서버 오류",
        "example": "",
        "eng_mean": ""
	}]""");
      return returnValue.map((data) => WordModel.fromJson(data)).toList();
    }
  }
}
