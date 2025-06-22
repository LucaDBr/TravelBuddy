// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'itinerary_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ItineraryItem _$ItineraryItemFromJson(Map<String, dynamic> json) {
  return _ItineraryItem.fromJson(json);
}

/// @nodoc
mixin _$ItineraryItem {
  @JsonKey(ignore: true)
  String? get id => throw _privateConstructorUsedError;
  int get dayIndex => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  List<ItineraryPoint> get items => throw _privateConstructorUsedError;
  DateTime get lastModified => throw _privateConstructorUsedError;

  /// Serializes this ItineraryItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ItineraryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItineraryItemCopyWith<ItineraryItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItineraryItemCopyWith<$Res> {
  factory $ItineraryItemCopyWith(
          ItineraryItem value, $Res Function(ItineraryItem) then) =
      _$ItineraryItemCopyWithImpl<$Res, ItineraryItem>;
  @useResult
  $Res call(
      {@JsonKey(ignore: true) String? id,
      int dayIndex,
      DateTime date,
      DateTime endDate,
      List<ItineraryPoint> items,
      DateTime lastModified});
}

/// @nodoc
class _$ItineraryItemCopyWithImpl<$Res, $Val extends ItineraryItem>
    implements $ItineraryItemCopyWith<$Res> {
  _$ItineraryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItineraryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? dayIndex = null,
    Object? date = null,
    Object? endDate = null,
    Object? items = null,
    Object? lastModified = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      dayIndex: null == dayIndex
          ? _value.dayIndex
          : dayIndex // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ItineraryPoint>,
      lastModified: null == lastModified
          ? _value.lastModified
          : lastModified // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ItineraryItemImplCopyWith<$Res>
    implements $ItineraryItemCopyWith<$Res> {
  factory _$$ItineraryItemImplCopyWith(
          _$ItineraryItemImpl value, $Res Function(_$ItineraryItemImpl) then) =
      __$$ItineraryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(ignore: true) String? id,
      int dayIndex,
      DateTime date,
      DateTime endDate,
      List<ItineraryPoint> items,
      DateTime lastModified});
}

/// @nodoc
class __$$ItineraryItemImplCopyWithImpl<$Res>
    extends _$ItineraryItemCopyWithImpl<$Res, _$ItineraryItemImpl>
    implements _$$ItineraryItemImplCopyWith<$Res> {
  __$$ItineraryItemImplCopyWithImpl(
      _$ItineraryItemImpl _value, $Res Function(_$ItineraryItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of ItineraryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? dayIndex = null,
    Object? date = null,
    Object? endDate = null,
    Object? items = null,
    Object? lastModified = null,
  }) {
    return _then(_$ItineraryItemImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      dayIndex: null == dayIndex
          ? _value.dayIndex
          : dayIndex // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ItineraryPoint>,
      lastModified: null == lastModified
          ? _value.lastModified
          : lastModified // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ItineraryItemImpl implements _ItineraryItem {
  _$ItineraryItemImpl(
      {@JsonKey(ignore: true) this.id,
      required this.dayIndex,
      required this.date,
      required this.endDate,
      required final List<ItineraryPoint> items,
      required this.lastModified})
      : _items = items;

  factory _$ItineraryItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItineraryItemImplFromJson(json);

  @override
  @JsonKey(ignore: true)
  final String? id;
  @override
  final int dayIndex;
  @override
  final DateTime date;
  @override
  final DateTime endDate;
  final List<ItineraryPoint> _items;
  @override
  List<ItineraryPoint> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final DateTime lastModified;

  @override
  String toString() {
    return 'ItineraryItem(id: $id, dayIndex: $dayIndex, date: $date, endDate: $endDate, items: $items, lastModified: $lastModified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItineraryItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dayIndex, dayIndex) ||
                other.dayIndex == dayIndex) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.lastModified, lastModified) ||
                other.lastModified == lastModified));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, dayIndex, date, endDate,
      const DeepCollectionEquality().hash(_items), lastModified);

  /// Create a copy of ItineraryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItineraryItemImplCopyWith<_$ItineraryItemImpl> get copyWith =>
      __$$ItineraryItemImplCopyWithImpl<_$ItineraryItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItineraryItemImplToJson(
      this,
    );
  }
}

abstract class _ItineraryItem implements ItineraryItem {
  factory _ItineraryItem(
      {@JsonKey(ignore: true) final String? id,
      required final int dayIndex,
      required final DateTime date,
      required final DateTime endDate,
      required final List<ItineraryPoint> items,
      required final DateTime lastModified}) = _$ItineraryItemImpl;

  factory _ItineraryItem.fromJson(Map<String, dynamic> json) =
      _$ItineraryItemImpl.fromJson;

  @override
  @JsonKey(ignore: true)
  String? get id;
  @override
  int get dayIndex;
  @override
  DateTime get date;
  @override
  DateTime get endDate;
  @override
  List<ItineraryPoint> get items;
  @override
  DateTime get lastModified;

  /// Create a copy of ItineraryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItineraryItemImplCopyWith<_$ItineraryItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ItineraryPoint _$ItineraryPointFromJson(Map<String, dynamic> json) {
  return _ItineraryPoint.fromJson(json);
}

/// @nodoc
mixin _$ItineraryPoint {
  String get title => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;

  /// Serializes this ItineraryPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ItineraryPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItineraryPointCopyWith<ItineraryPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItineraryPointCopyWith<$Res> {
  factory $ItineraryPointCopyWith(
          ItineraryPoint value, $Res Function(ItineraryPoint) then) =
      _$ItineraryPointCopyWithImpl<$Res, ItineraryPoint>;
  @useResult
  $Res call({String title, String? notes, double latitude, double longitude});
}

/// @nodoc
class _$ItineraryPointCopyWithImpl<$Res, $Val extends ItineraryPoint>
    implements $ItineraryPointCopyWith<$Res> {
  _$ItineraryPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItineraryPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? notes = freezed,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ItineraryPointImplCopyWith<$Res>
    implements $ItineraryPointCopyWith<$Res> {
  factory _$$ItineraryPointImplCopyWith(_$ItineraryPointImpl value,
          $Res Function(_$ItineraryPointImpl) then) =
      __$$ItineraryPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String? notes, double latitude, double longitude});
}

/// @nodoc
class __$$ItineraryPointImplCopyWithImpl<$Res>
    extends _$ItineraryPointCopyWithImpl<$Res, _$ItineraryPointImpl>
    implements _$$ItineraryPointImplCopyWith<$Res> {
  __$$ItineraryPointImplCopyWithImpl(
      _$ItineraryPointImpl _value, $Res Function(_$ItineraryPointImpl) _then)
      : super(_value, _then);

  /// Create a copy of ItineraryPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? notes = freezed,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_$ItineraryPointImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ItineraryPointImpl implements _ItineraryPoint {
  _$ItineraryPointImpl(
      {required this.title,
      this.notes,
      required this.latitude,
      required this.longitude});

  factory _$ItineraryPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItineraryPointImplFromJson(json);

  @override
  final String title;
  @override
  final String? notes;
  @override
  final double latitude;
  @override
  final double longitude;

  @override
  String toString() {
    return 'ItineraryPoint(title: $title, notes: $notes, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItineraryPointImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, title, notes, latitude, longitude);

  /// Create a copy of ItineraryPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItineraryPointImplCopyWith<_$ItineraryPointImpl> get copyWith =>
      __$$ItineraryPointImplCopyWithImpl<_$ItineraryPointImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItineraryPointImplToJson(
      this,
    );
  }
}

abstract class _ItineraryPoint implements ItineraryPoint {
  factory _ItineraryPoint(
      {required final String title,
      final String? notes,
      required final double latitude,
      required final double longitude}) = _$ItineraryPointImpl;

  factory _ItineraryPoint.fromJson(Map<String, dynamic> json) =
      _$ItineraryPointImpl.fromJson;

  @override
  String get title;
  @override
  String? get notes;
  @override
  double get latitude;
  @override
  double get longitude;

  /// Create a copy of ItineraryPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItineraryPointImplCopyWith<_$ItineraryPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
