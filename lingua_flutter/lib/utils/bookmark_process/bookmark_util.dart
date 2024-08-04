import 'dart:convert';

import 'package:lingua/models/bookmark_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveBookmarks(List<BookmarkModel> bookmarkList) async {
  // BookmarkModel 인스턴스 리스트를 JSON 배열로 변환
  List<Map<String, dynamic>> jsonList =
      bookmarkList.map((bookmark) => bookmark.toJson()).toList();

  // JSON 배열을 문자열로 변환
  String jsonString = jsonEncode(jsonList);

  // SharedPreferences에 저장
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('bookmarks', jsonString);
}

Future<List<BookmarkModel>> loadBookmarks() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString('bookmarks');

  if (jsonString == null) {
    return [];
  }

  // 문자열을 JSON 배열로 변환하고 BookmarkModel 인스턴스 리스트로 변환
  List<dynamic> jsonList = jsonDecode(jsonString);
  List<BookmarkModel> bookmarkList =
      jsonList.map((json) => BookmarkModel.fromJson(json)).toList();

  return bookmarkList;
}
