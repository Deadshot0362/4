// lib/config/app_constants.dart
class AppConstants {
  // Platform Channel Names
  static const String notificationChannel = 'com.example.whatsapp_ai_assistant/notifications';
  static const String accessibilityChannel = 'com.example.whatsapp_ai_assistant/accessibility';
  static const String secureStorageChannel = 'com.example.whatsapp_ai_assistant/secure_storage';

  // OpenAI API
  static const String openAIBaseUrl = 'https://api.openai.com/v1';
  static const String openAIChatCompletionsEndpoint = '/chat/completions';
  static const String defaultOpenAIModel = 'gpt-3.5-turbo'; // Or gpt-4, gpt-4o etc.

  // Secure Storage Keys
  static const String openAIApiKey = 'OPENAI_API_KEY';
  static const String isNotificationListenerEnabledKey = 'IS_NOTIFICATION_LISTENER_ENABLED';
  static const String isAccessibilityServiceEnabledKey = 'IS_ACCESSIBILITY_SERVICE_ENABLED';

  // WhatsApp Package Name
  static const String whatsAppPackageName = 'com.whatsapp';

  // AI Personality Presets (Example prompts)
  static const Map<String, String> aiPersonalityPrompts = {
    'professional': 'You are a professional assistant. Respond formally and concisely. Focus on facts and direct answers.',
    'casual': 'You are a friendly and relaxed assistant. Use informal language, emojis, and a conversational tone.',
    'humorous': 'You are a witty and playful assistant. Incorporate jokes, puns, and lighthearted comments into your replies.',
  };

  // Default AI Personality
  static const String defaultAIPersonality = 'casual';

  // Conversation Memory
  static const int conversationMemoryLimit = 10; // Number of recent messages to keep for context

  // Data Retention Periods (in days)
  static const int dataRetention7Days = 7;
  static const int dataRetention30Days = 30;
  static const int dataRetention90Days = 90;
  static const int dataRetentionForever = 0; // 0 for infinite retention
}