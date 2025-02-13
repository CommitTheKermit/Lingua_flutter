// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'read_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReadOption _$ReadOptionFromJson(Map<String, dynamic> json) => ReadOption()
  ..optfontSize = (json['optfontSize'] as num).toDouble()
  ..optFontHeight = (json['optFontHeight'] as num).toDouble()
  ..optFontFamily = json['optFontFamily'] as String
  ..optcolorFont = (json['optcolorFont'] as num).toInt()
  ..optBackgroundColor = (json['optBackgroundColor'] as num).toInt();

Map<String, dynamic> _$ReadOptionToJson(ReadOption instance) =>
    <String, dynamic>{
      'optfontSize': instance.optfontSize,
      'optFontHeight': instance.optFontHeight,
      'optFontFamily': instance.optFontFamily,
      'optcolorFont': instance.optcolorFont,
      'optBackgroundColor': instance.optBackgroundColor,
    };
