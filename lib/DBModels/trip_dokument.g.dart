// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_dokument.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripDokumentImpl _$$TripDokumentImplFromJson(Map<String, dynamic> json) =>
    _$TripDokumentImpl(
      name: json['name'] as String,
      type: json['type'] as String,
      storagePath: json['storagePath'] as String,
      uploadedBy: json['uploadedBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TripDokumentImplToJson(_$TripDokumentImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'storagePath': instance.storagePath,
      'uploadedBy': instance.uploadedBy,
      'createdAt': instance.createdAt.toIso8601String(),
    };
