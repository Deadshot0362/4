import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:whatsapp_ai_assistant/config/app_constants.dart';
import 'package:whatsapp_ai_assistant/core/utils/app_logger.dart';
import 'package:whatsapp_ai_assistant/data/repositories/settings_repository.dart';
import 'package:whatsapp_ai_assistant/features/ai_settings/domain/entities/ai_personality.dart';
import 'package:whatsapp_ai_assistant/data/local/app_database.dart';

final Logger _logger = AppLogger.instance;

// Provider for OpenAI service
final openAIServiceProvider = Provider<OpenAIService>((ref) {
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  return OpenAIService(settingsRepo);
});

class OpenAIService {
  final SettingsRepository _settingsRepository;
  final String _baseUrl = AppConstants.openAIBaseUrl;

  OpenAIService(this._settingsRepository) {
    _logger.i('OpenAIService initialized.');
  }

  Future<String> getChatCompletion(String prompt) async {
    _logger.d('Requesting OpenAI chat completion for prompt: "$prompt"');
    try {
      // Dummy implementation for now, replace with actual API call
      // Example using http package:
      /*
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final String responseText = data['choices'][0]['message']['content'];
        _logger.i('OpenAI response: $responseText');
        return responseText;
      } else {
        _logger.e('Failed to get OpenAI response: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to get OpenAI response: ${response.body}');
      }
      */
      _logger.w('OpenAIService: Actual API call not implemented. Returning dummy response.');
      return 'This is a dummy AI response for: "$prompt"'; // Dummy response
    } catch (e, stack) {
      _logger.e('Error getting OpenAI completion: $e', error: e, stackTrace: stack);
      throw Exception('Error getting OpenAI completion: $e');
    }
  }

  /// Generate AI response based on conversation history and personality
  Future<String> getAIResponse({
    required List<Message> conversationHistory,
    required String newMessage,
    required AIPersonality aiPersonality,
  }) async {
    _logger.d('Generating AI response for new message: "$newMessage"');
    
    try {
      final apiKey = await _settingsRepository.getOpenAIApiKey();
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('OpenAI API key not configured');
      }

      // Build conversation context
      final messages = <Map<String, String>>[];
      
      // Add system message with personality
      messages.add({
        'role': 'system',
        'content': aiPersonality.prompt,
      });

      // Add conversation history
      for (final message in conversationHistory) {
        messages.add({
          'role': message.isUserMessage ? 'user' : 'assistant',
          'content': message.content,
        });
      }

      // Add new message
      messages.add({
        'role': 'user',
        'content': newMessage,
      });

      final response = await http.post(
        Uri.parse('$_baseUrl${AppConstants.openAIChatCompletionsEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          'model': AppConstants.defaultOpenAIModel,
          'messages': messages,
          'max_tokens': 150,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final String responseText = data['choices'][0]['message']['content'];
        _logger.i('OpenAI response generated successfully');
        return responseText.trim();
      } else {
        _logger.e('Failed to get OpenAI response: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to get OpenAI response: ${response.body}');
      }
    } catch (e, stack) {
      _logger.e('Error generating AI response: $e', error: e, stackTrace: stack);
      // Return a fallback response instead of throwing
      return 'I apologize, but I\'m having trouble generating a response right now. Please try again later.';
    }
  }
}