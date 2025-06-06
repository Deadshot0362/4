// lib/features/chat_management/presentation/providers/chat_monitor_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ai_assistant/core/utils/app_logger.dart';
import 'package:whatsapp_ai_assistant/data/repositories/conversation_repository.dart';
import 'package:whatsapp_ai_assistant/features/chat_management/domain/entities/chat_entity.dart';

/// Provider for streaming all monitored chats.
final monitoredChatsProvider = StreamProvider.autoDispose<List<ChatEntity>>((ref) {
  final repo = ref.watch(conversationRepositoryProvider);
  return repo.watchMonitoredChats();
});

/// Controller for managing chat monitoring states.
final chatMonitorControllerProvider = Provider((ref) {
  final repo = ref.watch(conversationRepositoryProvider);
  final logger = AppLogger.instance;

  return ChatMonitorController(repo, logger);
});

class ChatMonitorController {
  final ConversationRepository _conversationRepository;
  final Logger _logger;

  ChatMonitorController(this._conversationRepository, this._logger);

  Future<void> toggleChatMonitoring(int chatId, bool isMonitored) async {
    _logger.i('Toggling monitoring for chat ID $chatId to $isMonitored');
    try {
      await _conversationRepository.updateChatMonitoringStatus(chatId, isMonitored);
      _logger.d('Chat monitoring status updated successfully.');
    } catch (e) {
      _logger.e('Failed to update chat monitoring status for $chatId: $e');
      // Optionally re-throw or show error to user
    }
  }
}

// TODO: Implement chat statistics provider (e.g., total messages, avg response time)
final chatStatsProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  // Placeholder for fetching actual statistics from database
  // You would query the MessageRepository for counts and timestamps here.
  return {
    'totalMessagesProcessed': 0,
    'averageResponseTimeMs': 0,
  };
});