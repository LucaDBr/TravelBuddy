// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itinerary_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItineraryItemImpl _$$ItineraryItemImplFromJson(Map<String, dynamic> json) =>
    _$ItineraryItemImpl(
      dayIndex: (json['dayIndex'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      items: (json['items'] as List<dynamic>)
          .map((e) => ItineraryPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastModified: DateTime.parse(json['lastModified'] as String),
    );

Map<String, dynamic> _$$ItineraryItemImplToJson(_$ItineraryItemImpl instance) =>
    <String, dynamic>{
      'dayIndex': instance.dayIndex,
      'date': instance.date.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'items': instance.items,
      'lastModified': instance.lastModified.toIso8601String(),
    };

_$ItineraryPointImpl _$$ItineraryPointImplFromJson(Map<String, dynamic> json) =>
    _$ItineraryPointImpl(
      title: json['title'] as String,
      notes: json['notes'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$$ItineraryPointImplToJson(
  _$ItineraryPointImpl instance,
) => <String, dynamic>{
  'title': instance.title,
  'notes': instance.notes,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};
