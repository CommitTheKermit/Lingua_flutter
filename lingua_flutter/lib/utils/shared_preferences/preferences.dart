import 'dart:convert';

import 'package:lingua/utils/shared_preferences/prefs.dart';

// 값 저장
Future<void> setPrefString(String key, String value) async {
  Prefs().setString(key, value);
}

// 값 읽기
String? getPrefString(String key) {
  return Prefs().getString(key);
}

// 값 저장
Future<void> setPrefBool(String key, bool value) async {
  Prefs().setBool(key, value);
}

// 값 읽기
bool? getPrefBool(String key) {
  return Prefs().getBool(key);
}

Future<void> setPrefMap(
  String key,
  Map value,
) async {
  await Prefs().setString(key, json.encode(value));
}

Map<String, dynamic>? getPrefMap(
  String key,
) {
  Map<String, dynamic> returnMap;

  if (Prefs().getString(key) != null) {
    returnMap = json.decode(Prefs().getString(key)!);
    return returnMap;
  }
  return null;
}

Future<void> setPrefList(
  String key,
  List value,
) async {
  Map<String, dynamic> convertedMap = {
    for (int i = 0; i < value.length; i++) '$i': value[i]
  };
  await setPrefMap(key, convertedMap);
}

List? getPrefList(
  String key,
) {
  List returnList = [];

  Map? targetMap = getPrefMap(key);
  if (targetMap != null) {
    for (var entry in targetMap.entries) {
      returnList.insert(int.parse(entry.key), entry.value);
    }

    return returnList;
  }
  return null;
}

Future clearPrefs() async {
  String tempPhoneNumber = getPrefString('phoneNumber') ?? '';
  await Prefs().clear();
  setPrefString('phoneNumber', tempPhoneNumber);
}
