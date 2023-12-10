// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookmarkModel _$BookmarkModelFromJson(Map<String, dynamic> json) =>
    BookmarkModel(
      bookMarkedLine: json['bookMarkedLine'] as int,
      bookMarkedPage: json['bookMarkedPage'] as String,
      bookMarkedTime: DateTime.parse(json['bookMarkedTime'] as String),
    );

Map<String, dynamic> _$BookmarkModelToJson(BookmarkModel instance) =>
    <String, dynamic>{
      'bookMarkedLine': instance.bookMarkedLine,
      'bookMarkedTime': instance.bookMarkedTime.toIso8601String(),
      'bookMarkedPage': instance.bookMarkedPage,
    };
