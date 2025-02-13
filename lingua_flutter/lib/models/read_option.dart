import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:lingua/utils/shared_preferences/preferences.dart';

part 'read_option.g.dart';

@JsonSerializable()
class ReadOption {
  double optfontSize = 25;
  double optFontHeight = 1.7;
  String optFontFamily = 'Neo';
  int optcolorFont = 0xff000000;
  int optBackgroundColor = 0xffffffff;

ReadOption();

  ReadOption.full(this.optfontSize, this.optFontHeight, this.optFontFamily,
      this.optcolorFont, this.optBackgroundColor);

      

  ReadOption clone() {
    return ReadOption.full(optfontSize, optFontHeight, optFontFamily, optcolorFont,
        optBackgroundColor);
  }

  Future<void> loadOption({required String key}) async {
    String? jsonString = getPrefString(key);

    if (jsonString == null) {
      return;
    }
    Map<String, dynamic> json = jsonDecode(jsonString);

    if (json['optfontSize'] != null) {
      optfontSize = json['optfontSize'];
    }
    if (json['optFontHeight'] != null) {
      optFontHeight = json['optFontHeight'];
    }
    if (json['optFontFamily'] != null) {
      optFontFamily = json['optFontFamily'];
    }
    if (json['optcolorFont'] != null) {
      optcolorFont = json['optcolorFont'];
    }
    if (json['optBackgroundColor'] != null) {
      optBackgroundColor = json['optBackgroundColor'];
    }
  }

  Future<void> saveOption({required String key}) async {
    Map json = toJson();
    String jsonString = jsonEncode(json);

    setPrefString(key, jsonString);
  }

  factory ReadOption.fromJson(Map<String, dynamic> json) =>
      _$ReadOptionFromJson(json);
  Map<String, dynamic> toJson() => _$ReadOptionToJson(this);
}
// 옵션을 전부 저장하는 함수 하나 만들고
// 각각의 옵션을 세팅하는 세터에 그 함수에서 위 함수를 부르자
