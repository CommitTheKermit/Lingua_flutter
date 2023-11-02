import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lingua/util/shared_preferences/preference_manager.dart';

part 'read_option.g.dart';

@JsonSerializable()
class ReadOption {
  double optFontSize;
  double optFontHeight;
  String optFontFamily;
  int optFontColor;
  int optBackgroundColor;

  ReadOption(this.optFontSize, this.optFontHeight, this.optFontFamily,
      this.optFontColor, this.optBackgroundColor);

  ReadOption clone() {
    return ReadOption(optFontSize, optFontHeight, optFontFamily, optFontColor,
        optBackgroundColor);
  }

  Future<void> loadOption({required String key}) async {
    String? jsonString = await PreferenceManager.getValue(key);

    if (jsonString == null) {
      return;
    }
    Map<String, dynamic> json = jsonDecode(jsonString);

    if (json['optFontSize'] != null) {
      optFontSize = json['optFontSize'];
    }
    if (json['optFontHeight'] != null) {
      optFontHeight = json['optFontHeight'];
    }
    if (json['optFontFamily'] != null) {}
    if (json['optFontColor'] != null) {
      optFontColor = json['optFontColor'];
    }
    if (json['optBackgroundColor'] != null) {
      optBackgroundColor = json['optBackgroundColor'];
    }
  }

  Future<void> saveOption({required String key}) async {
    Map json = toJson();
    String jsonString = jsonEncode(json);

    PreferenceManager.saveValue(key, jsonString);
  }

  factory ReadOption.fromJson(Map<String, dynamic> json) =>
      _$ReadOptionFromJson(json);
  Map<String, dynamic> toJson() => _$ReadOptionToJson(this);
}
// 옵션을 전부 저장하는 함수 하나 만들고
// 각각의 옵션을 세팅하는 세터에 그 함수에서 위 함수를 부르자
