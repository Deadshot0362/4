// lib/features/ai_settings/domain/entities/ai_personality.dart
import 'package:whatsapp_ai_assistant/core/enums/ai_personality_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_personality.freezed.dart';

@freezed
class AIPersonality with _$AIPersonality {
  const factory AIPersonality({
    required AIPersonalityType type,
    required String prompt, // Base prompt for the AI
    @Default('neutral') String tone,
    @Default('neutral') String formality,
  }) = _AIPersonality;
}