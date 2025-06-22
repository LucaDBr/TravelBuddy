// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BudgetEntry _$BudgetEntryFromJson(Map<String, dynamic> json) {
  return _BudgetEntry.fromJson(json);
}

/// @nodoc
mixin _$BudgetEntry {
  @JsonKey(ignore: true)
  String? get id => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  double get planned => throw _privateConstructorUsedError;
  double? get actual => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;

  /// Serializes this BudgetEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BudgetEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BudgetEntryCopyWith<BudgetEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetEntryCopyWith<$Res> {
  factory $BudgetEntryCopyWith(
          BudgetEntry value, $Res Function(BudgetEntry) then) =
      _$BudgetEntryCopyWithImpl<$Res, BudgetEntry>;
  @useResult
  $Res call(
      {@JsonKey(ignore: true) String? id,
      String category,
      double planned,
      double? actual,
      String currency});
}

/// @nodoc
class _$BudgetEntryCopyWithImpl<$Res, $Val extends BudgetEntry>
    implements $BudgetEntryCopyWith<$Res> {
  _$BudgetEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BudgetEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? category = null,
    Object? planned = null,
    Object? actual = freezed,
    Object? currency = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      planned: null == planned
          ? _value.planned
          : planned // ignore: cast_nullable_to_non_nullable
              as double,
      actual: freezed == actual
          ? _value.actual
          : actual // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BudgetEntryImplCopyWith<$Res>
    implements $BudgetEntryCopyWith<$Res> {
  factory _$$BudgetEntryImplCopyWith(
          _$BudgetEntryImpl value, $Res Function(_$BudgetEntryImpl) then) =
      __$$BudgetEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(ignore: true) String? id,
      String category,
      double planned,
      double? actual,
      String currency});
}

/// @nodoc
class __$$BudgetEntryImplCopyWithImpl<$Res>
    extends _$BudgetEntryCopyWithImpl<$Res, _$BudgetEntryImpl>
    implements _$$BudgetEntryImplCopyWith<$Res> {
  __$$BudgetEntryImplCopyWithImpl(
      _$BudgetEntryImpl _value, $Res Function(_$BudgetEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of BudgetEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? category = null,
    Object? planned = null,
    Object? actual = freezed,
    Object? currency = null,
  }) {
    return _then(_$BudgetEntryImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      planned: null == planned
          ? _value.planned
          : planned // ignore: cast_nullable_to_non_nullable
              as double,
      actual: freezed == actual
          ? _value.actual
          : actual // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BudgetEntryImpl implements _BudgetEntry {
  _$BudgetEntryImpl(
      {@JsonKey(ignore: true) this.id,
      required this.category,
      required this.planned,
      this.actual,
      required this.currency});

  factory _$BudgetEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$BudgetEntryImplFromJson(json);

  @override
  @JsonKey(ignore: true)
  final String? id;
  @override
  final String category;
  @override
  final double planned;
  @override
  final double? actual;
  @override
  final String currency;

  @override
  String toString() {
    return 'BudgetEntry(id: $id, category: $category, planned: $planned, actual: $actual, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.planned, planned) || other.planned == planned) &&
            (identical(other.actual, actual) || other.actual == actual) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, category, planned, actual, currency);

  /// Create a copy of BudgetEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetEntryImplCopyWith<_$BudgetEntryImpl> get copyWith =>
      __$$BudgetEntryImplCopyWithImpl<_$BudgetEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BudgetEntryImplToJson(
      this,
    );
  }
}

abstract class _BudgetEntry implements BudgetEntry {
  factory _BudgetEntry(
      {@JsonKey(ignore: true) final String? id,
      required final String category,
      required final double planned,
      final double? actual,
      required final String currency}) = _$BudgetEntryImpl;

  factory _BudgetEntry.fromJson(Map<String, dynamic> json) =
      _$BudgetEntryImpl.fromJson;

  @override
  @JsonKey(ignore: true)
  String? get id;
  @override
  String get category;
  @override
  double get planned;
  @override
  double? get actual;
  @override
  String get currency;

  /// Create a copy of BudgetEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetEntryImplCopyWith<_$BudgetEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
