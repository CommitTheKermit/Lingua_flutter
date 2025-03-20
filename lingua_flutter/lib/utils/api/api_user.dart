import 'package:lingua/main.dart';
import 'package:lingua/models/server_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


const String baseUrl = ServerInfo.baseUrl;
const int timeoutSec = ServerInfo.timeoutSec;
late String? cookie;





Future<String> idFind(String phoneNo) async {
  final url = Uri.parse('$baseUrl/users/findemail');
  Map<String, dynamic> returnValue;

  return await http
      .post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'phone_no': phoneNo,
    }),
  )
      .then((response) {
    if (response.statusCode == 200) {
      // 서버가 성공적으로 응답하면 JSON을 파싱합니다.
      returnValue = json.decode(response.body);

      return returnValue['email'];
    } else {
      // 서버가 200 이외의 상태 코드로 응답하면 예외를 발생시킵니다.

      return 'nonexist';
    }
  }).timeout(const Duration(seconds: timeoutSec), onTimeout: () {
    return 'serverError';
  });
}

Future<bool> pwFind(String phoneNo, String email) async {
  final url = Uri.parse('$baseUrl/users/findpw');

  return await http
      .post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'phone_no': phoneNo,
      'email': email,
    }),
  )
      .then((response) {
    if (response.statusCode == 200) {
      // 서버가 성공적으로 응답하면 JSON을 파싱합니다.

      return true;
    } else {
      // 서버가 200 이외의 상태 코드로 응답하면 예외를 발생시킵니다.

      return false;
    }
  }).timeout(const Duration(seconds: timeoutSec), onTimeout: () {
    return false;
  });
}

Future<bool> pwChange({
  required String phoneNo,
  required String email,
}) async {
  final url = Uri.parse('$baseUrl/users/changepw');

  return await http
      .post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'phone_no': phoneNo,
      'email': email,
      'password': user.password,
    }),
  )
      .then((response) {
    if (response.statusCode == 200) {
      // 서버가 성공적으로 응답하면 JSON을 파싱합니다.
      return true;
    } else {
      // 서버가 200 이외의 상태 코드로 응답하면 예외를 발생시킵니다.

      return false;
    }
  }).timeout(const Duration(seconds: timeoutSec), onTimeout: () {
    return false;
  });
}

Future<int> periodicRefresh({
  //TODO
  required String email,
}) async {
  final url = Uri.parse('$baseUrl/users/refreshclient');

  return await http
      .post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'email': email,
    }),
  )
      .then((response) {
    if (response.statusCode == 200) {
      // 서버가 성공적으로 응답하면 JSON을 파싱합니다.
      Map<String, dynamic> answerJson;
      answerJson = jsonDecode(response.body);
      int requestQuota = answerJson['request_quota'];

      requestQuota = requestQuota;

      return requestQuota;
    } else {
      // 서버가 200 이외의 상태 코드로 응답하면 예외를 발생시킵니다.

      return 0;
    }
  }).timeout(const Duration(seconds: timeoutSec), onTimeout: () {
    return 0;
  });
}

Future<bool> setQuota({
  //TODO
  required String email,
  required int argQuota,
}) async {
  final url = Uri.parse('$baseUrl/users/refreshclient');

  return await http
      .post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'email': email,
      'request_qouta': argQuota,
    }),
  )
      .then((response) {
    if (response.statusCode == 200) {
      // 서버가 성공적으로 응답하면 JSON을 파싱합니다.
      requestQuota = argQuota;

      return true;
    } else {
      // 서버가 200 이외의 상태 코드로 응답하면 예외를 발생시킵니다.

      return false;
    }
  }).timeout(const Duration(seconds: timeoutSec), onTimeout: () {
    return false;
  });

}
