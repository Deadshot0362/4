// lib/core/enums/ai_personality_type.dart
enum AIPersonalityType {
  professional,
  casual,
  humorous,
  custom,
}

extension AIPersonalityTypeExtension on AIPersonalityType {
  String toDisplayString() {
    switch (this) {
      case AIPersonalityType.professional:
        return 'Professional';
      case AIPersonalityType.casual:
        return 'Casual';
      case AIPersonalityType.humorous:
        return 'Humorous';
      case AIPersonalityType.custom:
        return 'Custom';
    }
  }

  String toKey() {
    return toString().split('.').last;
  }
}

AIPersonalityType aiPersonalityTypeFromString(String? type) {
  if (type == null) return AIPersonalityType.casual; // Default
  switch (type.toLowerCase()) {
    case 'professional':
      return AIPersonalityType.professional;
    case 'casual':
      return AIPersonalityType.casual;
    case 'humorous':
      return AIPersonalityType.humorous;
    case 'custom':
      return AIPersonalityType.custom;
    default:
      return AIPersonalityType.casual;
  }
}