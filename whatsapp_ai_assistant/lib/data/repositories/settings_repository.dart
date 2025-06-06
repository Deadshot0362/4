// lib/data/repositories/settings_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:whatsapp_ai_assistant/config/app_constants.dart';
import 'package:whatsapp_ai_assistant/core/enums/ai_personality_type.dart';
import 'package:whatsapp_ai_assistant/core/utils/app_logger.dart';
import 'package:whatsapp_ai_assistant/features/ai_settings/domain/entities/ai_personality.dart';
import 'package:whatsapp_ai_assistant/features/privacy_settings/domain/entities/data_retention_period.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(secureStorageProvider));
});

class SettingsRepository {
  final FlutterSecureStorage _secureStorage;
  final Logger _logger = AppLogger.instance;

  SettingsRepository(this._secureStorage);

  // --- OpenAI API Key ---
  Future<void> saveOpenAIApiKey(String key) async {
    _logger.d('Saving OpenAI API key...');
    await _secureStorage.write(key: AppConstants.openAIApiKey, value: key);
  }

  Future<String?> getOpenAIApiKey() async {
    _logger.d('Retrieving OpenAI API key...');
    return await _secureStorage.read(key: AppConstants.openAIApiKey);
  }

  // --- AI Personality Settings ---
  Future<void> saveSelectedAIPersonality(AIPersonalityType type) async {
    _logger.d('Saving selected AI personality: ${type.toKey()}');
    await _secureStorage.write(key: 'ai_personality_type', value: type.toKey());
  }

  Future<AIPersonalityType> getSelectedAIPersonality() async {
    final String? type = await _secureStorage.read(key: 'ai_personality_type');
    _logger.d('Retrieved AI personality: $type');
    return aiPersonalityTypeFromString(type);
  }

  Future<void> saveCustomAIPersonality(AIPersonality personality) async {
    _logger.d('Saving custom AI personality prompt...');
    await _secureStorage.write(key: 'custom_ai_prompt', value: personality.prompt);
    await _secureStorage.write(key: 'custom_ai_tone', value: personality.tone);
    await _secureStorage.write(key: 'custom_ai_formality', value: personality.formality);
  }

  Future<AIPersonality> getCustomAIPersonality() async {
    _logger.d('Retrieving custom AI personality...');
    final prompt = await _secureStorage.read(key: 'custom_ai_prompt');
    final tone = await _secureStorage.read(key: 'custom_ai_tone');
    final formality = await _secureStorage.read(key: 'custom_ai_formality');

    return AIPersonality(
      type: AIPersonalityType.custom,
      prompt: prompt ?? 'You are a helpful AI assistant.',
      tone: tone ?? 'neutral',
      formality: formality ?? 'neutral',
    );
  }

  // --- Data Retention Settings ---
  Future<void> saveDataRetentionPeriod(DataRetentionPeriod period) async {
    _logger.d('Saving data retention period: ${period.toKey()}');
    await _secureStorage.write(key: 'data_retention_period', value: period.toKey());
  }

  Future<DataRetentionPeriod> getDataRetentionPeriod() async {
    final String? periodKey = await _secureStorage.read(key: 'data_retention_period');
    _logger.d('Retrieved data retention period: $periodKey');
    return dataRetentionPeriodFromString(periodKey);
  }
}