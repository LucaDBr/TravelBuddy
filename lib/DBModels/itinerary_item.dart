import 'package:freezed_annotation/freezed_annotation.dart';

part 'itinerary_item.freezed.dart';
part 'itinerary_item.g.dart';

@freezed
class ItineraryItem with _$ItineraryItem {
  factory ItineraryItem({
    @JsonKey(ignore: true) String? id,
    required int dayIndex,
    required DateTime date,
    required DateTime endDate,
    required List<ItineraryPoint> items,
    required DateTime lastModified,
  }) = _ItineraryItem;

  factory ItineraryItem.fromJson(Map<String, dynamic> json) =>
      _$ItineraryItemFromJson(json);
}

@freezed
class ItineraryPoint with _$ItineraryPoint {
  factory ItineraryPoint({
    required String title,
    String? notes,
    required double latitude,
    required double longitude,
  }) = _ItineraryPoint;

  factory ItineraryPoint.fromJson(Map<String, dynamic> json) =>
      _$ItineraryPointFromJson(json);
}
