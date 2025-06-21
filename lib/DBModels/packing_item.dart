import 'package:freezed_annotation/freezed_annotation.dart';

part 'packing_item.freezed.dart';
part 'packing_item.g.dart';

@freezed
class PackingItem with _$PackingItem {
  factory PackingItem({
    @JsonKey(ignore: true) String? id,
    required String item,
    String? category,
    @Default(1) int quantity,
    @Default(false) bool packed,
    String? packedBy,
  }) = _PackingItem;

  factory PackingItem.fromJson(Map<String, dynamic> json) =>
      _$PackingItemFromJson(json);
}
