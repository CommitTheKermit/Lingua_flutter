import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lingua/main.dart';
import 'package:lingua/utils/shared_preferences/preferences.dart';
import 'package:lingua/widgets/commons/common_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<dynamic> apiPost({
  required String uri,
  required body,
  dynamic argHeaders,
  String? urlHeader,
}) async {
  late Headers headrerObj;
  late Response response;
  try {
    Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10), // 연결 타임아웃 10초
        receiveTimeout: const Duration(seconds: 10), // 데이터 수신 타임아웃 10초
      ),
    );
    String? ipAdress = await getIPAddress();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'auth-token': getPrefString('authToken') ?? '',
      'refresh-token': getPrefString('refreshToken') ?? '',
      'Connection': 'Keep-Alive',
      // 192.168.90.158
    };
    if (ipAdress != null) {
      headers['X-FORWARDED-FOR'] = ipAdress;
      if (const String.fromEnvironment("DEPLOY") != 'prod') {
        headers['X-FORWARDED-FOR'] = '192.168.90.158';
      }
    }
    if (argHeaders == null) {
      dio.options.headers = headers;
    } else {
      dio.options.headers = argHeaders;
    }

    if (body.runtimeType == FormData) {
      response = await dio.post(
        urlHeader != null ? '$urlHeader$uri' : '$baseApiUrl/api$uri',
        data: body,
      );
    } else {
      response = await dio.post(
        urlHeader != null ? '$urlHeader$uri' : '$baseApiUrl/api$uri',
        data: json.encode(body),
      );
    }

    headrerObj = response.headers;

    if (response.statusCode == 403 &&
        response.data['message'] == 'Access Denied' &&
        getPrefString('authToken') != null) {
      try {
        removeToken();
        // Navigator.push(
        //   navKey.currentContext!,
        //   MaterialPageRoute(builder: (context) => const LoginPage()),
        // );
        showToast('토큰이 만료되어 로그인 페이지로 이동합니다.');
        // ignore: empty_catches
      } catch (e, stackTrace) {
        FlutterError.reportError(FlutterErrorDetails(
          exception: e,
          stack: stackTrace,
        ));
        throw Exception();
      }
      return;
    }
  } catch (e, stackTrace) {
    FlutterError.reportError(FlutterErrorDetails(
      exception: e,
      stack: stackTrace,
    ));
    throw Exception();
  }

  if (headrerObj["new_token"] != null) {
    setPrefString('authToken', headrerObj["new_token"].toString());
  }
  response.data['responseStatusCode'] = response.statusCode;
  return response.data;
}

Future<dynamic> apiGet({required String uri, Map<String, String>? argHeaders}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? ipAdress = await getIPAddress();
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'auth-token': prefs.getString('authToken').toString(),
    'refresh-token': prefs.getString('refreshToken').toString()
  };

  if (ipAdress != null) {
    headers['X-FORWARDED-FOR'] = ipAdress;
    if (const String.fromEnvironment("DEPLOY") != 'prod') {
      headers['X-FORWARDED-FOR'] = '192.168.90.158';
    }
  }
  Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20), // 연결 타임아웃 10초
      receiveTimeout: const Duration(seconds: 20), // 데이터 수신 타임아웃 10초
    ),
  );
  if (argHeaders == null) {
    dio.options.headers = headers;
  } else {
    dio.options.headers = argHeaders;
  }
  Response response = await dio.get(
    '$baseApiUrl/api$uri',
  );
  var headrerObj = response.headers;

//  if (response.statusCode != 200) {
//    if (response.statusCode == 403) {
//      removeToken();
//    }
//  }
  if (response.statusCode == 403 &&
      response.data['message'] == 'Access Denied' &&
      prefs.getString('authToken') != null) {
    try {
      removeToken();
      // Navigator.push(
      //   navKey.currentContext!,
      //   MaterialPageRoute(builder: (context) => const LoginPage()),
      // );
      showToast('토큰이 만료되어 로그인 페이지로 이동합니다.');
      // ignore: empty_catches
    } catch (e, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: e,
        stack: stackTrace,
      ));
    }
    return;
  }

  if (headrerObj["new_token"] != null) {
    prefs.setString('authToken', headrerObj["new_token"].toString());
  }

  return response.data;
}

void removeToken() async {
  try {
    var resObj = await apiGet(uri: '/deleteFbToken');

    if (resObj['code'] == 'OK') {
    } else {
      showToast("네트워크 상태를 체크해 주세요.");
    }
  } catch (e, stackTrace) {
    FlutterError.reportError(FlutterErrorDetails(
      exception: e,
      stack: stackTrace,
    ));
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('authToken');
  prefs.remove('refreshToken');
  prefs.remove('custBizId');
}

// Future<String?> getPublicIPAddress() async {
//   try {
//     Dio dio = Dio();
//     Response response = await dio.get(
//       'https://api64.ipify.org',
//     );
//
//     dio.options.headers = {
//       'Content-Type': 'application/json',
//     };
//     if (response.statusCode == 200) {
//       // 응답을 JSON으로 변환
//       return response.data; // 'ip' 필드에서 공인 IP 추출
//     } else {
//       return null;
//     }
//   } catch (e) {
//     return null;
//   }
//
//   return null;
// }

Future<String?> getIPAddress() async {
  try {
    // 네트워크 인터페이스 목록 가져오기
    List<NetworkInterface> interfaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4, // IPv4만 가져오기
      includeLoopback: false, // 루프백 주소 제외
    );

    return interfaces.last.addresses.last.address;
  } catch (e) {
    return '0.0.0.0';
  }
}
