import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Map을 JSON으로 변환하고 파일로 저장하는 함수
Future<void> saveMapToFile(
    {required Map<String, String> map, required String filename}) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$filename');
  await file.writeAsString(jsonEncode(map));
}

// 파일에서 JSON을 읽어 Map으로 변환하는 함수
Future<Map<String, String>> loadMapFromFile({required String filename}) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');
    String contents = await file.readAsString();
    Map<String, String> map = Map<String, String>.from(jsonDecode(contents));
    return map;
  } catch (e) {
    // 파일이 존재하지 않거나 에러 발생 시 빈 Map 반환
    return {};
  }
}
