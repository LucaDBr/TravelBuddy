// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packing_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PackingItemImpl _$$PackingItemImplFromJson(Map<String, dynamic> json) =>
    _$PackingItemImpl(
      item: json['item'] as String,
      category: json['category'] as String?,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      packed: json['packed'] as bool? ?? false,
      packedBy: json['packedBy'] as String?,
    );

Map<String, dynamic> _$$PackingItemImplToJson(_$PackingItemImpl instance) =>
    <String, dynamic>{
      'item': instance.item,
      'category': instance.category,
      'quantity': instance.quantity,
      'packed': instance.packed,
      'packedBy': instance.packedBy,
    };
