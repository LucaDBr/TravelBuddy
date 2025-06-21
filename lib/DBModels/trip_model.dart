import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_model.freezed.dart';
part 'trip_model.g.dart';

@freezed
class TripModel with _$TripModel {
  factory TripModel({
    @JsonKey(ignore: true) String? id,
    required String title,
    DateTime? startDate,
    DateTime? endDate,
    String? destination,
    String? description,
    required String ownerUid,
    required List<String> members,
    required DateTime createdAt,
  }) = _TripModel;

  factory TripModel.fromJson(Map<String, dynamic> json) =>
      _$TripModelFromJson(json);
}
