// lib/features/conversation_history/presentation/providers/conversation_history_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ai_assistant/data/repositories/conversation_repository.dart';
import 'package:whatsapp_ai_assistant/data/repositories/message_repository.dart';
import 'package:whatsapp_ai_assistant/features/chat_management/domain/entities/chat_entity.dart';
import 'package:whatsapp_ai_assistant/features/conversation_history/domain/entities/conversation_entity.dart';

/// Provides a list of all recorded conversations (chats).
final allConversationsProvider = FutureProvider.autoDispose<List<ChatEntity>>((ref) async {
  final repo = ref.watch(conversationRepositoryProvider);
  return repo.getAllChats();
});

/// Provides a stream of messages for a specific conversation ID.
final messagesForConversationProvider =
    StreamProvider.family.autoDispose<List<MessageEntity>, int>((ref, conversationId) {
  final repo = ref.watch(messageRepositoryProvider);
  return repo.watchMessagesForConversation(conversationId);
});

// TODO: Add a provider for searchable history if needed.