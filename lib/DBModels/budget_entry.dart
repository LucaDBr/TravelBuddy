import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_entry.freezed.dart';
part 'budget_entry.g.dart';

@freezed
class BudgetEntry with _$BudgetEntry {
  factory BudgetEntry({
    @JsonKey(ignore: true) String? id,
    required String category,
    required double planned,
    double? actual,
    required String currency,
  }) = _BudgetEntry;

  factory BudgetEntry.fromJson(Map<String, dynamic> json) =>
      _$BudgetEntryFromJson(json);
}
