// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatEntity _$ChatEntityFromJson(Map<String, dynamic> json) => _ChatEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      isMonitored: json['isMonitored'] as bool,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      lastMessageTime: json['lastMessageTime'] == null
          ? null
          : DateTime.parse(json['lastMessageTime'] as String),
    );

Map<String, dynamic> _$ChatEntityToJson(_ChatEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isMonitored': instance.isMonitored,
      'unreadCount': instance.unreadCount,
      'lastMessageTime': instance.lastMessageTime?.toIso8601String(),
    };
