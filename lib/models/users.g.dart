// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Users _$UsersFromJson(Map<String, dynamic> json) => Users(
      u_id: json['u_id'] as int?,
      first_name: json['first_name'] as String?,
      Last_name: json['Last_name'] as String?,
      email: json['email'] as String?,
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
    );

Map<String, dynamic> _$UsersToJson(Users instance) => <String, dynamic>{
      'first_name': instance.first_name,
      'Last_name': instance.Last_name,
      'email': instance.email,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'u_id': instance.u_id,
    };
