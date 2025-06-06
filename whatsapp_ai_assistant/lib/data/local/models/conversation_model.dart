// lib/data/local/models/conversation_model.dart
import 'package:drift/drift.dart';

class Conversations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get chatIdentifier => text().unique()(); // E.g., WhatsApp JID or phone number
  TextColumn get chatName => text()(); // Display name
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isMonitored => boolean().withDefault(const Constant(true))(); // To allow selective chat monitoring
}