import 'package:lingua/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiUser {
  static const String baseUrl = "http://10.0.2.2:8000";
  static const int timeoutSec = 5;

  static Future<bool> signUp() {
    final url = Uri.parse('$baseUrl/users/signup');

    return http
        .post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': UserModel.email,
        'password': UserModel.password,
        'phone_no': UserModel.phoneNo,
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

  static Future<bool> emailSend(String email) async {
    final url = Uri.parse('$baseUrl/users/mailsend');

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
      const Duration(seconds: timeoutSec),
      onTimeout: () => false, // 3초 후에 실행될 대체값입니다.
    );
  }

  static Future<bool> emailVerify(String email, String code) async {
    final url = Uri.parse('$baseUrl/users/mailverify');
    // final response = await http.post(
    //   url,
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode({'user_code': code}),
    // );
    //
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
      body: jsonEncode({
        'email': email,
        'user_code': code,
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

  static Future<bool> login() async {
    final url = Uri.parse('$baseUrl/users/login');

    return await http
        .post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': UserModel.email,
        'password': UserModel.password,
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

  static Future<String> idFind(String phoneNo) async {
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

  static Future<bool> pwFind(String phoneNo, String email) async {
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

  static Future<bool> pwChange({
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
        'password': UserModel.password,
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
}
