// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel()
  ..email = json['email'] as String
  ..password = json['password'] as String
  ..phoneNo = json['phoneNo'] as String
  ..callLimit = (json['callLimit'] as num).toInt();

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'phoneNo': instance.phoneNo,
      'callLimit': instance.callLimit,
    };
