import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_dokument.freezed.dart';
part 'trip_dokument.g.dart';

@freezed
class TripDokument with _$TripDokument {
  factory TripDokument({
    @JsonKey(ignore: true) String? id,
    required String name,
    required String type,
    required String storagePath,
    required String uploadedBy,
    required DateTime createdAt,
  }) = _TripDokument;

  factory TripDokument.fromJson(Map<String, dynamic> json) =>
      _$TripDokumentFromJson(json);
}
