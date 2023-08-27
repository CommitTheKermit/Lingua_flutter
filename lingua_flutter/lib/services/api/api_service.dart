import 'package:lingua/models/user_model.dart';
import 'package:lingua/models/word_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000";

  static Future<List<WordModel>> dictSearch(String argText) async {
    List<dynamic> returnValue;
    final url = Uri.parse('$baseUrl/dictionary/word/');
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

        ApiService.wordRecord(argText);
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
    }).timeout(const Duration(seconds: 3), onTimeout: () {
      return returnValue = json.decode("""[{
        "kor": "",
        "pos": "",
        "meaning": "서버 오류",
        "example": "",
        "eng_mean": ""
	}]""");
    });
  }

  static Future<bool> emailSend(String email) async {
    final url = Uri.parse('$baseUrl/users/mailsend/');

    return await http
        .post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'email': email}),
    )
        .then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }).timeout(
      const Duration(seconds: 3),
      onTimeout: () => false, // 3초 후에 실행될 대체값입니다.
    );
  }

  static Future<bool> emailVerification(String code) async {
    final url = Uri.parse('$baseUrl/users/mailverify/');
    // final response = await http.post(
    //   url,
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode({'user_code': code}),
    // );

    // if (response.statusCode == 200) {
    //   // 서버가 성공적으로 응답하면 JSON을 파싱합니다.
    //   return true;
    // } else {
    //   return false;
    // }

    return await http
        .post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'user_code': code}),
    )
        .then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }).timeout(
      const Duration(seconds: 3),
      onTimeout: () => false, // 3초 후에 실행될 대체값입니다.
    );
  }

  static Future<bool> wordRecord(String argText) async {
    final url = Uri.parse('$baseUrl/users/mailverify/');

    return await http
        .post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'word': argText, 'email': UserModel.email}),
    )
        .then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }).timeout(
      const Duration(seconds: 3),
      onTimeout: () => false, // 3초 후에 실행될 대체값입니다.
    );
  }
}
