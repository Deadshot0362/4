// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConversationEntity {
  String get id;
  String get name;
  bool get isMonitored;
  List<Message> get messages; // Correctly references Drift's Message class
  DateTime? get lastMessageTime;

  /// Create a copy of ConversationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConversationEntityCopyWith<ConversationEntity> get copyWith =>
      _$ConversationEntityCopyWithImpl<ConversationEntity>(
          this as ConversationEntity, _$identity);

  /// Serializes this ConversationEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConversationEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isMonitored, isMonitored) ||
                other.isMonitored == isMonitored) &&
            const DeepCollectionEquality().equals(other.messages, messages) &&
            (identical(other.lastMessageTime, lastMessageTime) ||
                other.lastMessageTime == lastMessageTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, isMonitored,
      const DeepCollectionEquality().hash(messages), lastMessageTime);

  @override
  String toString() {
    return 'ConversationEntity(id: $id, name: $name, isMonitored: $isMonitored, messages: $messages, lastMessageTime: $lastMessageTime)';
  }
}

/// @nodoc
abstract mixin class $ConversationEntityCopyWith<$Res> {
  factory $ConversationEntityCopyWith(
          ConversationEntity value, $Res Function(ConversationEntity) _then) =
      _$ConversationEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      bool isMonitored,
      List<Message> messages,
      DateTime? lastMessageTime});
}

/// @nodoc
class _$ConversationEntityCopyWithImpl<$Res>
    implements $ConversationEntityCopyWith<$Res> {
  _$ConversationEntityCopyWithImpl(this._self, this._then);

  final ConversationEntity _self;
  final $Res Function(ConversationEntity) _then;

  /// Create a copy of ConversationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isMonitored = null,
    Object? messages = null,
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
      messages: null == messages
          ? _self.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<Message>,
      lastMessageTime: freezed == lastMessageTime
          ? _self.lastMessageTime
          : lastMessageTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _ConversationEntity implements ConversationEntity {
  const _ConversationEntity(
      {required this.id,
      required this.name,
      required this.isMonitored,
      final List<Message> messages = const [],
      this.lastMessageTime})
      : _messages = messages;
  factory _ConversationEntity.fromJson(Map<String, dynamic> json) =>
      _$ConversationEntityFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final bool isMonitored;
  final List<Message> _messages;
  @override
  @JsonKey()
  List<Message> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

// Correctly references Drift's Message class
  @override
  final DateTime? lastMessageTime;

  /// Create a copy of ConversationEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConversationEntityCopyWith<_ConversationEntity> get copyWith =>
      __$ConversationEntityCopyWithImpl<_ConversationEntity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ConversationEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConversationEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isMonitored, isMonitored) ||
                other.isMonitored == isMonitored) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            (identical(other.lastMessageTime, lastMessageTime) ||
                other.lastMessageTime == lastMessageTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, isMonitored,
      const DeepCollectionEquality().hash(_messages), lastMessageTime);

  @override
  String toString() {
    return 'ConversationEntity(id: $id, name: $name, isMonitored: $isMonitored, messages: $messages, lastMessageTime: $lastMessageTime)';
  }
}

/// @nodoc
abstract mixin class _$ConversationEntityCopyWith<$Res>
    implements $ConversationEntityCopyWith<$Res> {
  factory _$ConversationEntityCopyWith(
          _ConversationEntity value, $Res Function(_ConversationEntity) _then) =
      __$ConversationEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      bool isMonitored,
      List<Message> messages,
      DateTime? lastMessageTime});
}

/// @nodoc
class __$ConversationEntityCopyWithImpl<$Res>
    implements _$ConversationEntityCopyWith<$Res> {
  __$ConversationEntityCopyWithImpl(this._self, this._then);

  final _ConversationEntity _self;
  final $Res Function(_ConversationEntity) _then;

  /// Create a copy of ConversationEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isMonitored = null,
    Object? messages = null,
    Object? lastMessageTime = freezed,
  }) {
    return _then(_ConversationEntity(
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
      messages: null == messages
          ? _self._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<Message>,
      lastMessageTime: freezed == lastMessageTime
          ? _self.lastMessageTime
          : lastMessageTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
