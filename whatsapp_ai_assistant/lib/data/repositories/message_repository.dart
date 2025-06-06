// lib/data/repositories/message_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ai_assistant/core/utils/app_logger.dart';
import 'package:whatsapp_ai_assistant/data/local/app_database.dart';
import 'package:whatsapp_ai_assistant/data/local/daos/messages_dao.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return MessageRepository(database.messagesDao);
});

class MessageRepository {
  final MessagesDao _messagesDao;
  final Logger _logger = AppLogger.instance;
  final _uuid = const Uuid();

  MessageRepository(this._messagesDao);

  Future<void> saveMessage(String conversationId, String sender, String content) async {
    _logger.d('Saving message to conversation $conversationId: $sender - $content');
    final message = MessagesCompanion.insert(
      id: _uuid.v4(),
      conversationId: conversationId,
      content: content,
      timestamp: DateTime.now(),
      isUserMessage: sender == 'user',
    );
    await _messagesDao.insertMessage(message);
  }

  Future<List<Message>> getMessagesForConversation(String conversationId, {int limit = 10, int offset = 0}) async {
    _logger.d('Fetching messages for conversation ID: $conversationId (limit: $limit, offset: $offset)');
    return await _messagesDao.getMessagesForConversation(conversationId, limit: limit, offset: offset);
  }

  Stream<List<Message>> watchMessagesForConversation(String conversationId) {
    _logger.d('Watching messages for conversation ID: $conversationId');
    return _messagesDao.watchMessagesForConversation(conversationId);
  }

  Future<List<Message>> getRecentMessagesForConversation(String conversationId, int limit) async {
    _logger.d('Fetching recent messages for conversation ID: $conversationId (limit: $limit)');
    return await _messagesDao.getRecentMessagesForConversation(conversationId, limit);
  }
}