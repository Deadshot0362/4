// lib/features/ai_settings/presentation/screens/ai_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ai_assistant/core/enums/ai_personality_type.dart';
import 'package:whatsapp_ai_assistant/core/utils/app_logger.dart';
import 'package:whatsapp_ai_assistant/features/ai_settings/domain/entities/ai_personality.dart';
import 'package:whatsapp_ai_assistant/features/ai_settings/presentation/providers/ai_personality_providers.dart';
import 'package:whatsapp_ai_assistant/ui/shared_widgets/custom_app_bar.dart';

class AISettingsScreen extends ConsumerWidget {
  const AISettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPersonalityType = ref.watch(selectedAIPersonalityTypeProvider);
    final customPersonality = ref.watch(customAIPersonalityProvider);
    final aiSettingsController = ref.watch(aiSettingsControllerProvider);
    final Logger logger = AppLogger.instance;

    final openAIApiKeyController = TextEditingController();
    final customPromptController = TextEditingController();
    final customToneController = TextEditingController();
    final customFormalityController = TextEditingController();

    // Load initial API Key
    ref.read(aiSettingsControllerProvider).loadOpenAIApiKey().then((key) {
      if (key != null) openAIApiKeyController.text = key;
    });

    // Load initial Custom Personality
    ref.read(aiSettingsControllerProvider).loadCustomPersonality().then((personality) {
      customPromptController.text = personality.prompt;
      customToneController.text = personality.tone;
      customFormalityController.text = personality.formality;
    });

    return Scaffold(
      appBar: CustomAppBar(
        title: 'AI Settings',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('OpenAI API Key', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: openAIApiKeyController,
              decoration: InputDecoration(
                hintText: 'Enter your OpenAI API Key',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () async {
                    await aiSettingsController.saveOpenAIApiKey(openAIApiKeyController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('API Key saved securely!')));
                  },
                ),
              ),
              obscureText: true, // Hide sensitive key
            ),
            const SizedBox(height: 30),
            Text('AI Personality Presets', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...AIPersonalityType.values.where((type) => type != AIPersonalityType.custom).map((type) {
              return RadioListTile<AIPersonalityType>(
                title: Text(type.toDisplayString()),
                value: type,
                groupValue: selectedPersonalityType,
                onChanged: (AIPersonalityType? value) {
                  if (value != null) {
                    aiSettingsController.selectAIPersonality(value);
                  }
                },
              );
            }).toList(),
            RadioListTile<AIPersonalityType>(
              title: Text(AIPersonalityType.custom.toDisplayString()),
              value: AIPersonalityType.custom,
              groupValue: selectedPersonalityType,
              onChanged: (AIPersonalityType? value) {
                if (value != null) {
                  aiSettingsController.selectAIPersonality(value);
                }
              },
            ),
            if (selectedPersonalityType == AIPersonalityType.custom) ...[
              const SizedBox(height: 20),
              Text('Custom Personality Parameters', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: customPromptController,
                decoration: const InputDecoration(
                  labelText: 'Custom Prompt (e.g., "You are a friendly pirate")',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) => aiSettingsController.updateCustomPersonality(
                    customPersonality.value?.copyWith(prompt: value)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: customToneController,
                decoration: const InputDecoration(
                  labelText: 'Tone (e.g., "sarcastic", "empathetic")',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => aiSettingsController.updateCustomPersonality(
                    customPersonality.value?.copyWith(tone: value)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: customFormalityController,
                decoration: const InputDecoration(
                  labelText: 'Formality (e.g., "formal", "informal")',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => aiSettingsController.updateCustomPersonality(
                    customPersonality.value?.copyWith(formality: value)),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  await aiSettingsController.saveCustomPersonality(
                    customPromptController.text,
                    customToneController.text,
                    customFormalityController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Custom personality saved!')));
                },
                icon: const Icon(Icons.save),
                label: const Text('Save Custom Personality'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              ),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}