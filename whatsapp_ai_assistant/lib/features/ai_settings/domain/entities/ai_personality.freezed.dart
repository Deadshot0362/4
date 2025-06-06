// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_personality.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AIPersonality {
  AIPersonalityType get type;
  String get prompt; // Base prompt for the AI
  String get tone;
  String get formality;

  /// Create a copy of AIPersonality
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AIPersonalityCopyWith<AIPersonality> get copyWith =>
      _$AIPersonalityCopyWithImpl<AIPersonality>(
          this as AIPersonality, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AIPersonality &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            (identical(other.tone, tone) || other.tone == tone) &&
            (identical(other.formality, formality) ||
                other.formality == formality));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, prompt, tone, formality);

  @override
  String toString() {
    return 'AIPersonality(type: $type, prompt: $prompt, tone: $tone, formality: $formality)';
  }
}

/// @nodoc
abstract mixin class $AIPersonalityCopyWith<$Res> {
  factory $AIPersonalityCopyWith(
          AIPersonality value, $Res Function(AIPersonality) _then) =
      _$AIPersonalityCopyWithImpl;
  @useResult
  $Res call(
      {AIPersonalityType type, String prompt, String tone, String formality});
}

/// @nodoc
class _$AIPersonalityCopyWithImpl<$Res>
    implements $AIPersonalityCopyWith<$Res> {
  _$AIPersonalityCopyWithImpl(this._self, this._then);

  final AIPersonality _self;
  final $Res Function(AIPersonality) _then;

  /// Create a copy of AIPersonality
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? prompt = null,
    Object? tone = null,
    Object? formality = null,
  }) {
    return _then(_self.copyWith(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as AIPersonalityType,
      prompt: null == prompt
          ? _self.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String,
      tone: null == tone
          ? _self.tone
          : tone // ignore: cast_nullable_to_non_nullable
              as String,
      formality: null == formality
          ? _self.formality
          : formality // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _AIPersonality implements AIPersonality {
  const _AIPersonality(
      {required this.type,
      required this.prompt,
      this.tone = 'neutral',
      this.formality = 'neutral'});

  @override
  final AIPersonalityType type;
  @override
  final String prompt;
// Base prompt for the AI
  @override
  @JsonKey()
  final String tone;
  @override
  @JsonKey()
  final String formality;

  /// Create a copy of AIPersonality
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AIPersonalityCopyWith<_AIPersonality> get copyWith =>
      __$AIPersonalityCopyWithImpl<_AIPersonality>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AIPersonality &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            (identical(other.tone, tone) || other.tone == tone) &&
            (identical(other.formality, formality) ||
                other.formality == formality));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, prompt, tone, formality);

  @override
  String toString() {
    return 'AIPersonality(type: $type, prompt: $prompt, tone: $tone, formality: $formality)';
  }
}

/// @nodoc
abstract mixin class _$AIPersonalityCopyWith<$Res>
    implements $AIPersonalityCopyWith<$Res> {
  factory _$AIPersonalityCopyWith(
          _AIPersonality value, $Res Function(_AIPersonality) _then) =
      __$AIPersonalityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {AIPersonalityType type, String prompt, String tone, String formality});
}

/// @nodoc
class __$AIPersonalityCopyWithImpl<$Res>
    implements _$AIPersonalityCopyWith<$Res> {
  __$AIPersonalityCopyWithImpl(this._self, this._then);

  final _AIPersonality _self;
  final $Res Function(_AIPersonality) _then;

  /// Create a copy of AIPersonality
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? type = null,
    Object? prompt = null,
    Object? tone = null,
    Object? formality = null,
  }) {
    return _then(_AIPersonality(
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as AIPersonalityType,
      prompt: null == prompt
          ? _self.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String,
      tone: null == tone
          ? _self.tone
          : tone // ignore: cast_nullable_to_non_nullable
              as String,
      formality: null == formality
          ? _self.formality
          : formality // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
