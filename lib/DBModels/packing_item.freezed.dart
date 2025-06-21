// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'packing_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PackingItem _$PackingItemFromJson(Map<String, dynamic> json) {
  return _PackingItem.fromJson(json);
}

/// @nodoc
mixin _$PackingItem {
  @JsonKey(ignore: true)
  String? get id => throw _privateConstructorUsedError;
  String get item => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  bool get packed => throw _privateConstructorUsedError;
  String? get packedBy => throw _privateConstructorUsedError;

  /// Serializes this PackingItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PackingItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PackingItemCopyWith<PackingItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PackingItemCopyWith<$Res> {
  factory $PackingItemCopyWith(
    PackingItem value,
    $Res Function(PackingItem) then,
  ) = _$PackingItemCopyWithImpl<$Res, PackingItem>;
  @useResult
  $Res call({
    @JsonKey(ignore: true) String? id,
    String item,
    String? category,
    int quantity,
    bool packed,
    String? packedBy,
  });
}

/// @nodoc
class _$PackingItemCopyWithImpl<$Res, $Val extends PackingItem>
    implements $PackingItemCopyWith<$Res> {
  _$PackingItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PackingItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? item = null,
    Object? category = freezed,
    Object? quantity = null,
    Object? packed = null,
    Object? packedBy = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            item: null == item
                ? _value.item
                : item // ignore: cast_nullable_to_non_nullable
                      as String,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            packed: null == packed
                ? _value.packed
                : packed // ignore: cast_nullable_to_non_nullable
                      as bool,
            packedBy: freezed == packedBy
                ? _value.packedBy
                : packedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PackingItemImplCopyWith<$Res>
    implements $PackingItemCopyWith<$Res> {
  factory _$$PackingItemImplCopyWith(
    _$PackingItemImpl value,
    $Res Function(_$PackingItemImpl) then,
  ) = __$$PackingItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(ignore: true) String? id,
    String item,
    String? category,
    int quantity,
    bool packed,
    String? packedBy,
  });
}

/// @nodoc
class __$$PackingItemImplCopyWithImpl<$Res>
    extends _$PackingItemCopyWithImpl<$Res, _$PackingItemImpl>
    implements _$$PackingItemImplCopyWith<$Res> {
  __$$PackingItemImplCopyWithImpl(
    _$PackingItemImpl _value,
    $Res Function(_$PackingItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PackingItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? item = null,
    Object? category = freezed,
    Object? quantity = null,
    Object? packed = null,
    Object? packedBy = freezed,
  }) {
    return _then(
      _$PackingItemImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        item: null == item
            ? _value.item
            : item // ignore: cast_nullable_to_non_nullable
                  as String,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        packed: null == packed
            ? _value.packed
            : packed // ignore: cast_nullable_to_non_nullable
                  as bool,
        packedBy: freezed == packedBy
            ? _value.packedBy
            : packedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PackingItemImpl implements _PackingItem {
  _$PackingItemImpl({
    @JsonKey(ignore: true) this.id,
    required this.item,
    this.category,
    this.quantity = 1,
    this.packed = false,
    this.packedBy,
  });

  factory _$PackingItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PackingItemImplFromJson(json);

  @override
  @JsonKey(ignore: true)
  final String? id;
  @override
  final String item;
  @override
  final String? category;
  @override
  @JsonKey()
  final int quantity;
  @override
  @JsonKey()
  final bool packed;
  @override
  final String? packedBy;

  @override
  String toString() {
    return 'PackingItem(id: $id, item: $item, category: $category, quantity: $quantity, packed: $packed, packedBy: $packedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PackingItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.item, item) || other.item == item) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.packed, packed) || other.packed == packed) &&
            (identical(other.packedBy, packedBy) ||
                other.packedBy == packedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, item, category, quantity, packed, packedBy);

  /// Create a copy of PackingItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PackingItemImplCopyWith<_$PackingItemImpl> get copyWith =>
      __$$PackingItemImplCopyWithImpl<_$PackingItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PackingItemImplToJson(this);
  }
}

abstract class _PackingItem implements PackingItem {
  factory _PackingItem({
    @JsonKey(ignore: true) final String? id,
    required final String item,
    final String? category,
    final int quantity,
    final bool packed,
    final String? packedBy,
  }) = _$PackingItemImpl;

  factory _PackingItem.fromJson(Map<String, dynamic> json) =
      _$PackingItemImpl.fromJson;

  @override
  @JsonKey(ignore: true)
  String? get id;
  @override
  String get item;
  @override
  String? get category;
  @override
  int get quantity;
  @override
  bool get packed;
  @override
  String? get packedBy;

  /// Create a copy of PackingItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PackingItemImplCopyWith<_$PackingItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
