import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whatsapp_ai_assistant/data/local/app_database.dart'; // Import Drift generated classes

part 'chat_entity.freezed.dart';
part 'chat_entity.g.dart'; // Assuming you also want JSON serialization

@freezed
class ChatEntity with _$ChatEntity {
  const factory ChatEntity({
    required String id,
    required String name,
    required bool isMonitored, // Assuming this is part of your chat entity
    @Default(0) int unreadCount,
    DateTime? lastMessageTime, // Optional: if you want to display last message time
  }) = _ChatEntity;

  factory ChatEntity.fromJson(Map<String, dynamic> json) => _$ChatEntityFromJson(json);

  // Factory to create ChatEntity from Drift's Conversation data class
  factory ChatEntity.fromDriftConversation(Conversation conversation) {
    return ChatEntity(
      id: conversation.id,
      name: conversation.name,
      isMonitored: conversation.isMonitored,
      unreadCount: 0, // Default for now, or fetch from other source if applicable
      lastMessageTime: conversation.lastMessageTime,
    );
  }
}