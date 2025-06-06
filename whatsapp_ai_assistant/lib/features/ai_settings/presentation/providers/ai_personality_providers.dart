// lib/features/ai_settings/presentation/providers/ai_personality_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ai_assistant/core/enums/ai_personality_type.dart';
import 'package:whatsapp_ai_assistant/core/utils/app_logger.dart';
import 'package:whatsapp_ai_assistant/data/repositories/settings_repository.dart';
import 'package:whatsapp_ai_assistant/features/ai_settings/domain/entities/ai_personality.dart';

/// StateProvider for the currently selected AI personality type (e.g., Professional, Casual, Custom).
final selectedAIPersonalityTypeProvider = StateNotifierProvider<SelectedAIPersonalityTypeNotifier, AIPersonalityType>((ref) {
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  return SelectedAIPersonalityTypeNotifier(settingsRepo, AppLogger.instance);
});

class SelectedAIPersonalityTypeNotifier extends StateNotifier<AIPersonalityType> {
  final SettingsRepository _settingsRepository;
  final Logger _logger;

  SelectedAIPersonalityTypeNotifier(this._settingsRepository, this._logger) : super(AIPersonalityType.casual) {
    _loadSelectedPersonality();
  }

  Future<void> _loadSelectedPersonality() async {
    state = await _settingsRepository.getSelectedAIPersonality();
    _logger.d('Loaded selected AI personality: ${state.toDisplayString()}');
  }

  Future<void> selectPersonality(AIPersonalityType type) async {
    state = type;
    await _settingsRepository.saveSelectedAIPersonality(type);
    _logger.i('Selected AI personality updated to: ${type.toDisplayString()}');
  }
}

/// StateProvider for the custom AI personality details.
final customAIPersonalityProvider = StateNotifierProvider<CustomAIPersonalityNotifier, AIPersonality>((ref) {
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  return CustomAIPersonalityNotifier(settingsRepo, AppLogger.instance);
});

class CustomAIPersonalityNotifier extends StateNotifier<AIPersonality> {
  final SettingsRepository _settingsRepository;
  final Logger _logger;

  CustomAIPersonalityNotifier(this._settingsRepository, this._logger)
      : super(const AIPersonality(type: AIPersonalityType.custom, prompt: 'You are a helpful AI assistant.')) {
    _loadCustomPersonality();
  }

  Future<void> _loadCustomPersonality() async {
    state = await _settingsRepository.getCustomAIPersonality();
    _logger.d('Loaded custom AI personality: ${state.prompt}');
  }

  void updateCustomPersonality(AIPersonality? updatedPersonality) {
    if (updatedPersonality != null) {
      state = updatedPersonality;
    }
  }

  Future<void> saveCustomPersonality(String prompt, String tone, String formality) async {
    final newPersonality = AIPersonality(
      type: AIPersonalityType.custom,
      prompt: prompt,
      tone: tone,
      formality: formality,
    );
    state = newPersonality;
    await _settingsRepository.saveCustomAIPersonality(newPersonality);
    _logger.i('Custom AI personality saved.');
  }
}

/// Controller to encapsulate AI settings logic.
final aiSettingsControllerProvider = Provider((ref) {
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  final selectedPersonalityNotifier = ref.watch(selectedAIPersonalityTypeProvider.notifier);
  final customPersonalityNotifier = ref.watch(customAIPersonalityProvider.notifier);
  final logger = AppLogger.instance;

  return AISettingsController(
    settingsRepo,
    selectedPersonalityNotifier,
    customPersonalityNotifier,
    logger,
  );
});

class AISettingsController {
  final SettingsRepository _settingsRepository;
  final SelectedAIPersonalityTypeNotifier _selectedPersonalityNotifier;
  final CustomAIPersonalityNotifier _customPersonalityNotifier;
  final Logger _logger;

  AISettingsController(this._settingsRepository, this._selectedPersonalityNotifier,
      this._customPersonalityNotifier, this._logger);

  Future<String?> loadOpenAIApiKey() => _settingsRepository.getOpenAIApiKey();
  Future<void> saveOpenAIApiKey(String key) => _settingsRepository.saveOpenAIApiKey(key);

  Future<AIPersonality> loadCustomPersonality() => _settingsRepository.getCustomAIPersonality();
  Future<void> saveCustomPersonality(String prompt, String tone, String formality) =>
      _customPersonalityNotifier.saveCustomPersonality(prompt, tone, formality);
  void updateCustomPersonality(AIPersonality? updatedPersonality) =>
      _customPersonalityNotifier.updateCustomPersonality(updatedPersonality);

  Future<void> selectAIPersonality(AIPersonalityType type) =>
      _selectedPersonalityNotifier.selectPersonality(type);
}