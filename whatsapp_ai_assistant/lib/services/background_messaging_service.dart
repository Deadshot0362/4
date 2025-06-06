// lib/services/background_messaging_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:whatsapp_ai_assistant/api/openai_service.dart';
import 'package:whatsapp_ai_assistant/config/app_constants.dart';
import 'package:whatsapp_ai_assistant/core/enums/ai_personality_type.dart';
import 'package:whatsapp_ai_assistant/core/utils/app_logger.dart';
import 'package:whatsapp_ai_assistant/core/utils/platform_channels.dart';
import 'package:whatsapp_ai_assistant/data/local/app_database.dart';
import 'package:whatsapp_ai_assistant/data/repositories/conversation_repository.dart';
import 'package:whatsapp_ai_assistant/data/repositories/message_repository.dart';
import 'package:whatsapp_ai_assistant/data/repositories/settings_repository.dart';
import 'package:whatsapp_ai_assistant/features/ai_settings/domain/entities/ai_personality.dart';

/// This service acts as the orchestrator for background message processing.
/// It listens for incoming WhatsApp messages, determines if they should be processed by AI,
/// generates AI responses, and triggers auto-replies.
class BackgroundMessagingService {
  late ProviderContainer _container;
  final Logger _logger = AppLogger.instance;
  final PlatformChannels _platformChannels = PlatformChannels();

  BackgroundMessagingService() {
    _container = ProviderContainer(); // Create a new container for background tasks
  }

  /// Initializes the service by setting up dependencies.
  Future<void> init() async {
    // Ensure core dependencies are initialized for background context
    _container.read(appDatabaseProvider); // Accessing it once initializes the database
    _container.read(settingsRepositoryProvider); // Accessing it initializes secure storage
    _container.read(openAIServiceProvider); // Initializes the OpenAI service
    _container.read(conversationRepositoryProvider);
    _container.read(messageRepositoryProvider);
  }

  /// Starts listening to incoming WhatsApp messages and processing them.
  void start() {
    _platformChannels.incomingWhatsAppMessages.listen((messageData) async {
      _logger.i('Received WhatsApp message from native: $messageData');

      final String? chatIdentifier = messageData['chatIdentifier'] as String?;
      final String? chatName = messageData['chatName'] as String?;
      final String? sender = messageData['sender'] as String?;
      final String? content = messageData['content'] as String?;

      if (chatIdentifier == null || chatName == null || sender == null || content == null) {
        _logger.w('Incomplete message data received: $messageData');
        return;
      }

      // Check if this chat is monitored
      final conversationRepo = _container.read(conversationRepositoryProvider);
      final messageRepo = _container.read(messageRepositoryProvider);
      final openAIService = _container.read(openAIServiceProvider);
      final settingsRepo = _container.read(settingsRepositoryProvider);

      try {
        final chatEntity = await conversationRepo.getOrCreateChat(chatIdentifier, chatName);
        
        if (!chatEntity.isMonitored) {
          _logger.i('Chat "$chatName" is not monitored. Skipping AI response.');
          return;
        }

        // Save the incoming message to database
        await messageRepo.saveMessage(chatEntity.id, 'user', content);

        // Get conversation history for context
        final recentMessages = await messageRepo.getRecentMessagesForConversation(
          chatEntity.id,
          AppConstants.conversationMemoryLimit,
        );

        // Get AI personality settings
        final selectedPersonalityType = await settingsRepo.getSelectedAIPersonality();
        final aiPersonality = selectedPersonalityType == AIPersonalityType.custom
            ? await settingsRepo.getCustomAIPersonality()
            : AIPersonality(
                type: selectedPersonalityType,
                prompt: AppConstants.aiPersonalityPrompts[selectedPersonalityType.toKey()]!,
              );


        _logger.i('Generating AI response for message from "$sender" in "$chatName": "$content"');
        final aiResponse = await openAIService.getAIResponse(
          conversationHistory: recentMessages,
          newMessage: content,
          aiPersonality: aiPersonality,
        );

        _logger.i('AI Response generated: "$aiResponse"');

        // Save AI response to database
        await messageRepo.saveMessage(chatEntity.id, 'ai', aiResponse);

        // Send AI response via Accessibility Service
        final bool sent = await _platformChannels.sendMessageViaAccessibility(chatName, aiResponse);
        if (sent) {
          _logger.i('Successfully sent AI response to "$chatName" via Accessibility Service.');
        } else {
          _logger.w('Failed to send AI response to "$chatName" via Accessibility Service.');
          // TODO: Potentially notify user if auto-reply fails
        }
      } catch (e) {
        _logger.e('Error processing WhatsApp message for AI response: $e');
        // TODO: Handle errors, e.g., show a persistent notification to the user about failure
      }
    }, onError: (error) {
      _logger.e('Error in background message stream: $error');
    });

    _logger.i('BackgroundMessagingService listening for messages.');
  }

  void dispose() {
    _container.dispose();
    _logger.i('BackgroundMessagingService disposed.');
  }
}