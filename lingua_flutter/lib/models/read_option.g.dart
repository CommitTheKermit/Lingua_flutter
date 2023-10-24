// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'read_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReadOption _$ReadOptionFromJson(Map<String, dynamic> json) => ReadOption(
      (json['optFontSize'] as num).toDouble(),
      (json['optFontHeight'] as num).toDouble(),
      json['optFontFamily'] as String,
      json['optFontColor'] as int,
      json['optBackgroundColor'] as int,
    );

Map<String, dynamic> _$ReadOptionToJson(ReadOption instance) =>
    <String, dynamic>{
      'optFontSize': instance.optFontSize,
      'optFontHeight': instance.optFontHeight,
      'optFontFamily': instance.optFontFamily,
      'optFontColor': instance.optFontColor,
      'optBackgroundColor': instance.optBackgroundColor,
    };
