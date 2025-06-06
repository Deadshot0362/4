import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whatsapp_ai_assistant/data/local/app_database.dart'; // Import Drift generated classes

part 'conversation_entity.freezed.dart';
part 'conversation_entity.g.dart'; // Assuming you also want JSON serialization

@freezed
class ConversationEntity with _$ConversationEntity {
  const factory ConversationEntity({
    required String id,
    required String name,
    required bool isMonitored,
    @Default([]) List<Message> messages, // Correctly references Drift's Message class
    DateTime? lastMessageTime,
  }) = _ConversationEntity;

  factory ConversationEntity.fromJson(Map<String, dynamic> json) => _$ConversationEntityFromJson(json);

  // Factory to create ConversationEntity from Drift's Conversation data class
  factory ConversationEntity.fromDriftConversation(Conversation conversation, {List<Message> messages = const []}) {
    return ConversationEntity(
      id: conversation.id,
      name: conversation.name,
      isMonitored: conversation.isMonitored,
      lastMessageTime: conversation.lastMessageTime,
      messages: messages, // Pass messages or default to empty list
    );
  }
}