// lib/data/local/models/message_model.dart
import 'package:drift/drift.dart';

class Messages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get conversationId => integer().references(Conversations, #id)();
  TextColumn get sender => text()(); // 'user' or 'ai'
  TextColumn get content => text()();
  DateTimeColumn get timestamp => dateTime()();
}