import 'dart:io';

import 'package:lingua/main.dart';
import 'package:lingua/models/server_info.dart';
import 'package:lingua/models/user_model.dart';
import 'package:lingua/models/word_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';




  //  Future<bool> wordRecord({required String word}) async {
  //   final url = Uri.parse('$baseUrl/dictionary/wordbook');
  //
  //   return await http
  //       .post(
  //     url,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode({'word': word, 'email': UserModel.email}),
  //   )
  //       .then((response) {
  //     if (response.statusCode == 200) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   }).timeout(
  //     const Duration(seconds: timeoutSec),
  //     onTimeout: () => false, // 3초 후에 실행될 대체값입니다.
  //   );
  // }

  //  Future<bool> sendTranslatedText(String argText) async {
  //   final url = Uri.parse('$baseUrl/users/mailverify');
  //
  //   return http
  //       .post(
  //     url,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode({
  //       'word': argText,
  //       'email': UserModel.email,
  //     }),
  //   )
  //       .then((response) {
  //     if (response.statusCode == 200) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   }).timeout(
  //     const Duration(seconds: timeoutSec),
  //     onTimeout: () => false, // 3초 후에 실행될 대체값입니다.
  //   );
  // }



  // Future<bool> getApiKey() async {
  //   final url = Uri.parse('$baseUrl/util/getapikey');

  //   return await http.post(
  //     url,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //   ).then((response) {
  //     if (response.statusCode == 200) {
  //       ApiUtil.API_KEY = json.decode(response.body)['api_key'];
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   }).timeout(
  //     const Duration(seconds: timeoutSec),
  //     onTimeout: () => false, // 3초 후에 실행될 대체값입니다.
  //   );
  // }