import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:lingua/util/shared_preferences/preference_manager.dart';

part 'bookmark_model.g.dart';

@JsonSerializable()
class BookmarkModel {
  int bookMarkedLine;
  DateTime bookMarkedTime;
  String bookMarkedPage;

  BookmarkModel(
      {required this.bookMarkedLine,
      required this.bookMarkedPage,
      required this.bookMarkedTime});

  Future<void> loadOption({required String key}) async {
    String? jsonString = await PreferenceManager.getValue(key);

    if (jsonString == null) {
      return;
    }
    Map<String, dynamic> json = jsonDecode(jsonString);

    if (json.containsKey('bookMarkedLine')) {
      bookMarkedLine = json['bookMarkedLine'];
    }
    if (json.containsKey('bookMarkedPage')) {
      bookMarkedPage = json['bookMarkedPage'];
    }
    if (json.containsKey('bookMarkedTime')) {
      bookMarkedTime = json['bookMarkedTime'];
    }
  }

  Future<void> saveOption({required String key}) async {
    Map json = toJson();
    String jsonString = jsonEncode(json);

    PreferenceManager.saveValue(key, jsonString);
  }

  factory BookmarkModel.fromJson(Map<String, dynamic> json) =>
      _$BookmarkModelFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$BookmarkModelToJson(this);
}
