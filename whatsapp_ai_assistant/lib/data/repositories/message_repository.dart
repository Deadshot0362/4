// lib/data/repositories/message_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ai_assistant/core/utils/app_logger.dart';
import 'package:whatsapp_ai_assistant/data/local/app_database.dart';
import 'package:whatsapp_ai_assistant/data/local/models/message_model.dart';
import 'package:whatsapp_ai_assistant/features/conversation_history/domain/entities/conversation_entity.dart';
import 'package:drift/drift.dart' as drift;

final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return MessageRepository(database.messagesDao);
});

class MessageRepository {
  final MessagesDao _messagesDao;
  final Logger _logger = AppLogger.instance;

  MessageRepository(this._messagesDao);

  Future<void> saveMessage(int conversationId, String sender, String content) async {
    _logger.d('Saving message to conversation $conversationId: $sender - $content');
    final message = MessagesCompanion.insert(
      conversationId: conversationId,
      sender: sender,
      content: content,
      timestamp: DateTime.now(),
    );
    await _messagesDao.insertMessage(message);
  }

  Future<List<MessageEntity>> getMessagesForConversation(int conversationId, {int limit = 10, int offset = 0}) async {
    _logger.d('Fetching messages for conversation ID: $conversationId (limit: $limit, offset: $offset)');
    final messages = await _messagesDao.getMessagesForConversation(conversationId, limit: limit, offset: offset);
    return messages.map((m) => MessageEntity.fromMessage(m)).toList();
  }

  Stream<List<MessageEntity>> watchMessagesForConversation(int conversationId) {
    _logger.d('Watching messages for conversation ID: $conversationId');
    return _messagesDao.watchMessagesForConversation(conversationId).map((messages) {
      return messages.map((m) => MessageEntity.fromMessage(m)).toList();
    });
  }

  Future<List<MessageEntity>> getRecentMessagesForConversation(int conversationId, int limit) async {
    _logger.d('Fetching recent messages for conversation ID: $conversationId (limit: $limit)');
    final messages = await _messagesDao.getRecentMessagesForConversation(conversationId, limit);
    return messages.map((m) => MessageEntity.fromMessage(m)).toList();
  }
}