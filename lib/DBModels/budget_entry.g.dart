// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BudgetEntryImpl _$$BudgetEntryImplFromJson(Map<String, dynamic> json) =>
    _$BudgetEntryImpl(
      category: json['category'] as String,
      planned: (json['planned'] as num).toDouble(),
      actual: (json['actual'] as num?)?.toDouble(),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$$BudgetEntryImplToJson(_$BudgetEntryImpl instance) =>
    <String, dynamic>{
      'category': instance.category,
      'planned': instance.planned,
      'actual': instance.actual,
      'currency': instance.currency,
    };
