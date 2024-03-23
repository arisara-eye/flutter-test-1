// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Products _$ProductsFromJson(Map<String, dynamic> json) => Products(
      p_id: json['p_id'] as int?,
      p_name: json['p_name'] as String?,
      p_price: (json['p_price'] as num?)?.toDouble(),
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
      p_img: json['p_img'] as String?,
    );

Map<String, dynamic> _$ProductsToJson(Products instance) => <String, dynamic>{
      'p_name': instance.p_name,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'p_img': instance.p_img,
      'p_id': instance.p_id,
      'p_price': instance.p_price,
    };
