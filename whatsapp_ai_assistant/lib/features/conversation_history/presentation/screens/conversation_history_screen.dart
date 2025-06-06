// lib/features/conversation_history/presentation/screens/conversation_history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ai_assistant/core/utils/app_logger.dart';
import 'package:whatsapp_ai_assistant/features/conversation_history/domain/entities/conversation_entity.dart';
import 'package:whatsapp_ai_assistant/features/conversation_history/presentation/providers/conversation_history_providers.dart';
import 'package:whatsapp_ai_assistant/ui/shared_widgets/custom_app_bar.dart';
import 'package:whatsapp_ai_assistant/utils/helpers/date_time_formatter.dart';

class ConversationHistoryScreen extends ConsumerWidget {
  final int? chatId; // Optional: If navigating from a specific chat
  final String? chatName; // Optional: If navigating from a specific chat

  const ConversationHistoryScreen({Key? key, this.chatId, this.chatName}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Logger logger = AppLogger.instance;

    final asyncConversations = ref.watch(allConversationsProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: chatName ?? 'Conversation History',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: asyncConversations.when(
        data: (conversations) {
          if (conversations.isEmpty) {
            return const Center(child: Text('No conversations recorded yet.'));
          }
          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ExpansionTile(
                  title: Text(conversation.chatName),
                  subtitle: Text('ID: ${conversation.chatIdentifier} - Created: ${DateTimeFormatter.formatDate(conversation.createdAt)}'),
                  children: [
                    // Nested list of messages for this conversation
                    Consumer(
                      builder: (context, ref, child) {
                        final asyncMessages = ref.watch(messagesForConversationProvider(conversation.id));
                        return asyncMessages.when(
                          data: (messages) {
                            if (messages.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text('No messages in this conversation.'),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(), // Important for nested scroll views
                              itemCount: messages.length,
                              itemBuilder: (context, msgIndex) {
                                final message = messages[msgIndex];
                                return Align(
                                  alignment: message.sender == 'user' ? Alignment.centerRight : Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      color: message.sender == 'user' ? Colors.blue.shade100 : Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: message.sender == 'user' ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          message.content,
                                          style: TextStyle(
                                            color: message.sender == 'user' ? Colors.black87 : Colors.black,
                                          ),
                                        ),
                                        Text(
                                          DateTimeFormatter.formatTime(message.timestamp),
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (err, stack) {
                            logger.e('Error loading messages: $err');
                            return Center(child: Text('Error loading messages: $err'));
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          logger.e('Error loading conversations: $err');
          return Center(child: Text('Error loading conversations: $err'));
        },
      ),
    );
  }
}