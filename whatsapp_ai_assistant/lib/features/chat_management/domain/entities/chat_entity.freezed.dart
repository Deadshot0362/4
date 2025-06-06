// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatEntity {
  String get id;
  String get name;
  bool get isMonitored; // Assuming this is part of your chat entity
  int get unreadCount;
  DateTime? get lastMessageTime;

  /// Create a copy of ChatEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatEntityCopyWith<ChatEntity> get copyWith =>
      _$ChatEntityCopyWithImpl<ChatEntity>(this as ChatEntity, _$identity);

  /// Serializes this ChatEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isMonitored, isMonitored) ||
                other.isMonitored == isMonitored) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.lastMessageTime, lastMessageTime) ||
                other.lastMessageTime == lastMessageTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, isMonitored, unreadCount, lastMessageTime);

  @override
  String toString() {
    return 'ChatEntity(id: $id, name: $name, isMonitored: $isMonitored, unreadCount: $unreadCount, lastMessageTime: $lastMessageTime)';
  }
}

/// @nodoc
abstract mixin class $ChatEntityCopyWith<$Res> {
  factory $ChatEntityCopyWith(
          ChatEntity value, $Res Function(ChatEntity) _then) =
      _$ChatEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      bool isMonitored,
      int unreadCount,
      DateTime? lastMessageTime});
}

/// @nodoc
class _$ChatEntityCopyWithImpl<$Res> implements $ChatEntityCopyWith<$Res> {
  _$ChatEntityCopyWithImpl(this._self, this._then);

  final ChatEntity _self;
  final $Res Function(ChatEntity) _then;

  /// Create a copy of ChatEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isMonitored = null,
    Object? unreadCount = null,
    Object? lastMessageTime = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isMonitored: null == isMonitored
          ? _self.isMonitored
          : isMonitored // ignore: cast_nullable_to_non_nullable
              as bool,
      unreadCount: null == unreadCount
          ? _self.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastMessageTime: freezed == lastMessageTime
          ? _self.lastMessageTime
          : lastMessageTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _ChatEntity implements ChatEntity {
  const _ChatEntity(
      {required this.id,
      required this.name,
      required this.isMonitored,
      this.unreadCount = 0,
      this.lastMessageTime});
  factory _ChatEntity.fromJson(Map<String, dynamic> json) =>
      _$ChatEntityFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final bool isMonitored;
// Assuming this is part of your chat entity
  @override
  @JsonKey()
  final int unreadCount;
  @override
  final DateTime? lastMessageTime;

  /// Create a copy of ChatEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ChatEntityCopyWith<_ChatEntity> get copyWith =>
      __$ChatEntityCopyWithImpl<_ChatEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ChatEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChatEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isMonitored, isMonitored) ||
                other.isMonitored == isMonitored) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.lastMessageTime, lastMessageTime) ||
                other.lastMessageTime == lastMessageTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, isMonitored, unreadCount, lastMessageTime);

  @override
  String toString() {
    return 'ChatEntity(id: $id, name: $name, isMonitored: $isMonitored, unreadCount: $unreadCount, lastMessageTime: $lastMessageTime)';
  }
}

/// @nodoc
abstract mixin class _$ChatEntityCopyWith<$Res>
    implements $ChatEntityCopyWith<$Res> {
  factory _$ChatEntityCopyWith(
          _ChatEntity value, $Res Function(_ChatEntity) _then) =
      __$ChatEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      bool isMonitored,
      int unreadCount,
      DateTime? lastMessageTime});
}

/// @nodoc
class __$ChatEntityCopyWithImpl<$Res> implements _$ChatEntityCopyWith<$Res> {
  __$ChatEntityCopyWithImpl(this._self, this._then);

  final _ChatEntity _self;
  final $Res Function(_ChatEntity) _then;

  /// Create a copy of ChatEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isMonitored = null,
    Object? unreadCount = null,
    Object? lastMessageTime = freezed,
  }) {
    return _then(_ChatEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isMonitored: null == isMonitored
          ? _self.isMonitored
          : isMonitored // ignore: cast_nullable_to_non_nullable
              as bool,
      unreadCount: null == unreadCount
          ? _self.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastMessageTime: freezed == lastMessageTime
          ? _self.lastMessageTime
          : lastMessageTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
