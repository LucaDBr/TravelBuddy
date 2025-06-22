// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_dokument.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TripDokument _$TripDokumentFromJson(Map<String, dynamic> json) {
  return _TripDokument.fromJson(json);
}

/// @nodoc
mixin _$TripDokument {
  @JsonKey(ignore: true)
  String? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get storagePath => throw _privateConstructorUsedError;
  String get uploadedBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TripDokument to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TripDokument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripDokumentCopyWith<TripDokument> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripDokumentCopyWith<$Res> {
  factory $TripDokumentCopyWith(
          TripDokument value, $Res Function(TripDokument) then) =
      _$TripDokumentCopyWithImpl<$Res, TripDokument>;
  @useResult
  $Res call(
      {@JsonKey(ignore: true) String? id,
      String name,
      String type,
      String storagePath,
      String uploadedBy,
      DateTime createdAt});
}

/// @nodoc
class _$TripDokumentCopyWithImpl<$Res, $Val extends TripDokument>
    implements $TripDokumentCopyWith<$Res> {
  _$TripDokumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TripDokument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? type = null,
    Object? storagePath = null,
    Object? uploadedBy = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      storagePath: null == storagePath
          ? _value.storagePath
          : storagePath // ignore: cast_nullable_to_non_nullable
              as String,
      uploadedBy: null == uploadedBy
          ? _value.uploadedBy
          : uploadedBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TripDokumentImplCopyWith<$Res>
    implements $TripDokumentCopyWith<$Res> {
  factory _$$TripDokumentImplCopyWith(
          _$TripDokumentImpl value, $Res Function(_$TripDokumentImpl) then) =
      __$$TripDokumentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(ignore: true) String? id,
      String name,
      String type,
      String storagePath,
      String uploadedBy,
      DateTime createdAt});
}

/// @nodoc
class __$$TripDokumentImplCopyWithImpl<$Res>
    extends _$TripDokumentCopyWithImpl<$Res, _$TripDokumentImpl>
    implements _$$TripDokumentImplCopyWith<$Res> {
  __$$TripDokumentImplCopyWithImpl(
      _$TripDokumentImpl _value, $Res Function(_$TripDokumentImpl) _then)
      : super(_value, _then);

  /// Create a copy of TripDokument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? type = null,
    Object? storagePath = null,
    Object? uploadedBy = null,
    Object? createdAt = null,
  }) {
    return _then(_$TripDokumentImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      storagePath: null == storagePath
          ? _value.storagePath
          : storagePath // ignore: cast_nullable_to_non_nullable
              as String,
      uploadedBy: null == uploadedBy
          ? _value.uploadedBy
          : uploadedBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TripDokumentImpl implements _TripDokument {
  _$TripDokumentImpl(
      {@JsonKey(ignore: true) this.id,
      required this.name,
      required this.type,
      required this.storagePath,
      required this.uploadedBy,
      required this.createdAt});

  factory _$TripDokumentImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripDokumentImplFromJson(json);

  @override
  @JsonKey(ignore: true)
  final String? id;
  @override
  final String name;
  @override
  final String type;
  @override
  final String storagePath;
  @override
  final String uploadedBy;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'TripDokument(id: $id, name: $name, type: $type, storagePath: $storagePath, uploadedBy: $uploadedBy, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripDokumentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.storagePath, storagePath) ||
                other.storagePath == storagePath) &&
            (identical(other.uploadedBy, uploadedBy) ||
                other.uploadedBy == uploadedBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, type, storagePath, uploadedBy, createdAt);

  /// Create a copy of TripDokument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripDokumentImplCopyWith<_$TripDokumentImpl> get copyWith =>
      __$$TripDokumentImplCopyWithImpl<_$TripDokumentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripDokumentImplToJson(
      this,
    );
  }
}

abstract class _TripDokument implements TripDokument {
  factory _TripDokument(
      {@JsonKey(ignore: true) final String? id,
      required final String name,
      required final String type,
      required final String storagePath,
      required final String uploadedBy,
      required final DateTime createdAt}) = _$TripDokumentImpl;

  factory _TripDokument.fromJson(Map<String, dynamic> json) =
      _$TripDokumentImpl.fromJson;

  @override
  @JsonKey(ignore: true)
  String? get id;
  @override
  String get name;
  @override
  String get type;
  @override
  String get storagePath;
  @override
  String get uploadedBy;
  @override
  DateTime get createdAt;

  /// Create a copy of TripDokument
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripDokumentImplCopyWith<_$TripDokumentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
