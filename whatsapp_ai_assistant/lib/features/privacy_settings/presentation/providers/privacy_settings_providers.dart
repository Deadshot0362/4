// lib/features/privacy_settings/presentation/providers/privacy_settings_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ai_assistant/core/utils/app_logger.dart';
import 'package:whatsapp_ai_assistant/data/local/app_database.dart';
import 'package:whatsapp_ai_assistant/data/repositories/settings_repository.dart';
import 'package:whatsapp_ai_assistant/features/privacy_settings/domain/entities/data_retention_period.dart';

/// StateNotifier for the currently selected data retention period.
final dataRetentionPeriodProvider = StateNotifierProvider<DataRetentionPeriodNotifier, DataRetentionPeriod>((ref) {
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  return DataRetentionPeriodNotifier(settingsRepo, AppLogger.instance);
});

class DataRetentionPeriodNotifier extends StateNotifier<DataRetentionPeriod> {
  final SettingsRepository _settingsRepository;
  final Logger _logger;

  DataRetentionPeriodNotifier(this._settingsRepository, this._logger) : super(DataRetentionPeriod.forever) {
    _loadRetentionPeriod();
  }

  Future<void> _loadRetentionPeriod() async {
    state = await _settingsRepository.getDataRetentionPeriod();
    _logger.d('Loaded data retention period: ${state.toDisplayString()}');
  }

  Future<void> selectRetentionPeriod(DataRetentionPeriod period) async {
    state = period;
    await _settingsRepository.saveDataRetentionPeriod(period);
    _logger.i('Data retention period updated to: ${period.toDisplayString()}');
  }
}

/// Controller to encapsulate privacy settings logic.
final privacySettingsControllerProvider = Provider((ref) {
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  final retentionNotifier = ref.watch(dataRetentionPeriodProvider.notifier);
  final database = ref.watch(appDatabaseProvider); // Access database for cleaning
  final logger = AppLogger.instance;

  return PrivacySettingsController(
    settingsRepo,
    retentionNotifier,
    database,
    logger,
  );
});

class PrivacySettingsController {
  final SettingsRepository _settingsRepository;
  final DataRetentionPeriodNotifier _dataRetentionPeriodNotifier;
  final AppDatabase _appDatabase;
  final Logger _logger;

  PrivacySettingsController(this._settingsRepository, this._dataRetentionPeriodNotifier,
      this._appDatabase, this._logger);

  Future<void> selectDataRetentionPeriod(DataRetentionPeriod period) =>
      _dataRetentionPeriodNotifier.selectRetentionPeriod(period);

  Future<void> clearAllHistory() async {
    _logger.i('Initiating clear all conversation history...');
    try {
      await _appDatabase.delete(_appDatabase.messages).go();
      await _appDatabase.delete(_appDatabase.conversations).go();
      _logger.i('All conversation history cleared from database.');
    } catch (e) {
      _logger.e('Failed to clear conversation history: $e');
      // Handle error, e.g., show a snackbar to the user
    }
  }

  // This can be called periodically by the main app lifecycle or a background task
  Future<void> performScheduledDataCleanup() async {
    _logger.i('Performing scheduled data cleanup based on retention settings.');
    final currentRetentionPeriod = await _settingsRepository.getDataRetentionPeriod();
    final int retentionDays = currentRetentionPeriod.toDays();

    if (retentionDays > 0) {
      final DateTime cutoffDate = DateTime.now().subtract(Duration(days: retentionDays));
      _logger.i('Cleaning data older than: ${cutoffDate.toIso8601String()} (Retention: ${currentRetentionPeriod.toDisplayString()})');

      final messagesDeleted = await (_appDatabase.delete(_appDatabase.messages)
            ..where((tbl) => tbl.timestamp.isSmallerOrEqualValue(cutoffDate)))
          .go();
      _logger.i('Deleted $messagesDeleted old messages.');

      // Also clean up conversations that no longer have messages
      await _appDatabase.customStatement('DELETE FROM conversations WHERE id NOT IN (SELECT DISTINCT conversationId FROM messages)');
      _logger.i('Cleaned up empty conversations.');
    } else {
      _logger.i('Data retention is set to forever. No automated data cleaning performed.');
    }
  }
}