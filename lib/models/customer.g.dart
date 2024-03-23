// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      c_id: json['c_id'] as int?,
      c_name: json['c_name'] as String?,
      c_img: json['c_img'] as String?,
      c_address: json['c_address'] as String?,
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'c_name': instance.c_name,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'c_img': instance.c_img,
      'c_address': instance.c_address,
      'c_id': instance.c_id,
    };
