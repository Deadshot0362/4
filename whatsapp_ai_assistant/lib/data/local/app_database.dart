import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logger/logger.dart'; // Import the logger package
import 'package:whatsapp_ai_assistant/data/local/daos/conversations_dao.dart';
import 'package:whatsapp_ai_assistant/data/local/daos/messages_dao.dart';

part 'app_database.g.dart'; // Generated by drift_dev
part 'app_database.riverpod.dart'; // Generated by riverpod_generator

// Initialize the logger for this file
final Logger _logger = Logger();

// Define your tables with data class names for better readability
@DataClassName('Conversation')
class Conversations extends Table {
  TextColumn get id => text().customConstraint('UNIQUE').withLength(min: 1, max: 36)();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  BoolColumn get isMonitored => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastMessageTime => dateTime().nullable()();
  // Add other columns relevant to your conversation entity

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Message')
class Messages extends Table {
  TextColumn get id => text().customConstraint('UNIQUE')();
  // Reference to Conversations table
  TextColumn get conversationId => text().references(Conversations, #id, onDelete: KeyAction.cascade)();
  TextColumn get content => text()();
  DateTimeColumn get timestamp => dateTime()();
  BoolColumn get isUserMessage => boolean()();
  // Add other columns relevant to your message entity

  @override
  Set<Column> get primaryKey => {id};
}

// Function to open the database connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    _logger.i('Database path: ${file.path}');
    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(tables: [Conversations, Messages], daos: [ConversationsDao, MessagesDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1; // Increment this whenever your schema changes

  // Lazy getters for DAOs
  late final ConversationsDao conversationsDao = ConversationsDao(this);
  late final MessagesDao messagesDao = MessagesDao(this);

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          _logger.i('Creating database schema...');
          await m.createAll();
          _logger.i('Database schema created.');
        },
        onUpgrade: (Migrator m, int from, int to) async {
          _logger.i('Migrating database from version $from to $to...');
          // Implement your migration logic here when schemaVersion changes
          // Example:
          // if (from < 2) {
          //   await m.addColumn(conversations, conversations.newColumn);
          // }
          _logger.i('Database migration completed.');
        },
        beforeOpen: (details) async {
          // If you need to run checks or logic before the database is opened
          _logger.i('Database opened with details: $details');
          await customStatement('PRAGMA foreign_keys = ON'); // Ensure foreign key constraints are enabled
        },
      );
}

// Riverpod provider for the AppDatabase instance
@Riverpod(keepAlive: true) // keepAlive means it won't be disposed unless the app closes
AppDatabase appDatabase(AppDatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(() {
    _logger.i('AppDatabase disposed.');
    db.close(); // Close the database when the provider is disposed
  });
  return db;
}