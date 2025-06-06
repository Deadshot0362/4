// lib/features/privacy_settings/domain/entities/data_retention_period.dart
import 'package:whatsapp_ai_assistant/config/app_constants.dart';

enum DataRetentionPeriod {
  sevenDays,
  thirtyDays,
  ninetyDays,
  forever,
}

extension DataRetentionPeriodExtension on DataRetentionPeriod {
  String toDisplayString() {
    switch (this) {
      case DataRetentionPeriod.sevenDays:
        return '7 Days';
      case DataRetentionPeriod.thirtyDays:
        return '30 Days';
      case DataRetentionPeriod.ninetyDays:
        return '90 Days';
      case DataRetentionPeriod.forever:
        return 'Forever';
    }
  }

  String toKey() {
    return toString().split('.').last;
  }

  int toDays() {
    switch (this) {
      case DataRetentionPeriod.sevenDays:
        return AppConstants.dataRetention7Days;
      case DataRetentionPeriod.thirtyDays:
        return AppConstants.dataRetention30Days;
      case DataRetentionPeriod.ninetyDays:
        return AppConstants.dataRetention90Days;
      case DataRetentionPeriod.forever:
        return AppConstants.dataRetentionForever;
    }
  }
}

DataRetentionPeriod dataRetentionPeriodFromString(String? period) {
  if (period == null) return DataRetentionPeriod.forever; // Default
  switch (period.toLowerCase()) {
    case 'sevendays':
      return DataRetentionPeriod.sevenDays;
    case 'thirtydays':
      return DataRetentionPeriod.thirtyDays;
    case 'ninetydays':
      return DataRetentionPeriod.ninetyDays;
    case 'forever':
      return DataRetentionPeriod.forever;
    default:
      return DataRetentionPeriod.forever;
  }
}