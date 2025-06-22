import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_model.freezed.dart';
part 'trip_model.g.dart';

/// Firestore-Timestamp <-> DateTime Konverter
class TimestampDateTimeConverter implements JsonConverter<DateTime?, dynamic> {
  const TimestampDateTimeConverter();

  @override
  DateTime? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is Timestamp) return json.toDate();
    if (json is String) return DateTime.tryParse(json);
    return null;
  }

  @override
  dynamic toJson(DateTime? date) =>
      date == null ? null : Timestamp.fromDate(date);
}

@freezed
class TripModel with _$TripModel {
  factory TripModel({
    required String title,
    @TimestampDateTimeConverter() DateTime? startDate,
    @TimestampDateTimeConverter() DateTime? endDate,
    String? destination,
    String? description,
    required String ownerUid,
    @Default(<String>[]) List<String> members,
    @TimestampDateTimeConverter() required DateTime createdAt,
    @JsonKey(ignore: true) String? id,
  }) = _TripModel;

  factory TripModel.fromJson(Map<String, dynamic> json) =>
      _$TripModelFromJson(json);
}
