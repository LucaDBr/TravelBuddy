// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripModelImpl _$$TripModelImplFromJson(Map<String, dynamic> json) =>
    _$TripModelImpl(
      title: json['title'] as String,
      startDate: const TimestampDateTimeConverter().fromJson(json['startDate']),
      endDate: const TimestampDateTimeConverter().fromJson(json['endDate']),
      destination: json['destination'] as String?,
      description: json['description'] as String?,
      ownerUid: json['ownerUid'] as String,
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TripModelImplToJson(_$TripModelImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'startDate':
          const TimestampDateTimeConverter().toJson(instance.startDate),
      'endDate': const TimestampDateTimeConverter().toJson(instance.endDate),
      'destination': instance.destination,
      'description': instance.description,
      'ownerUid': instance.ownerUid,
      'members': instance.members,
      'createdAt': instance.createdAt.toIso8601String(),
    };
