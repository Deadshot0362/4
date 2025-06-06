// lib/features/chat_management/presentation/screens/chat_management_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ai_assistant/features/ai_settings/presentation/screens/ai_settings_screen.dart';
import 'package:whatsapp_ai_assistant/features/chat_management/presentation/providers/chat_monitor_providers.dart';
import 'package:whatsapp_ai_assistant/features/conversation_history/presentation/screens/conversation_history_screen.dart';
import 'package:whatsapp_ai_assistant/features/privacy_settings/presentation/screens/privacy_settings_screen.dart';
import 'package:whatsapp_ai_assistant/ui/shared_widgets/custom_app_bar.dart';

class ChatManagementScreen extends ConsumerWidget {
  const ChatManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMonitoredChats = ref.watch(monitoredChatsProvider);
    // final asyncChatStats = ref.watch(chatStatsProvider); // Not implemented yet, placeholder

    return Scaffold(
      appBar: CustomAppBar(
        title: 'WhatsApp AI Assistant',
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'ai_settings') {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AISettingsScreen()));
              } else if (value == 'privacy_settings') {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PrivacySettingsScreen()));
              } else if (value == 'history') {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ConversationHistoryScreen()));
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'ai_settings',
                child: Text('AI Settings'),
              ),
              const PopupMenuItem<String>(
                value: 'privacy_settings',
                child: Text('Privacy & Security'),
              ),
              const PopupMenuItem<String>(
                value: 'history',
                child: Text('Conversation History'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dashboard Overview', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    // Placeholder for stats
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text('Messages Processed'),
                            Text('N/A', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          children: [
                            Text('Avg. Response Time'),
                            Text('N/A', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Monitored Chats', style: Theme.of(context).textTheme.titleMedium),
          ),
          Expanded(
            child: asyncMonitoredChats.when(
              data: (chats) {
                if (chats.isEmpty) {
                  return const Center(
                    child: Text('No chats are currently monitored. Start by selecting chats in settings.'),
                  );
                }
                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return ListTile(
                      title: Text(chat.chatName),
                      subtitle: Text(chat.chatIdentifier),
                      trailing: Switch(
                        value: chat.isMonitored,
                        onChanged: (bool value) {
                          ref.read(chatMonitorControllerProvider).toggleChatMonitoring(chat.id, value);
                        },
                      ),
                      onTap: () {
                        // Optionally navigate to conversation history for this chat
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ConversationHistoryScreen(
                            chatId: chat.id,
                            chatName: chat.chatName,
                          ),
                        ));
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error loading chats: $err')),
            ),
          ),
        ],
      ),
    );
  }
}