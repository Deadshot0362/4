// lib/utils/helpers/date_time_formatter.dart
import 'package:intl/intl.dart'; // Add intl to pubspec.yaml if not already there

class DateTimeFormatter {
  static String formatDate(DateTime dateTime) {
    return DateFormat.yMMMd().format(dateTime); // e.g., Jun 7, 2025
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat.jm().format(dateTime); // e.g., 1:12 AM
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat.yMMMd().add_jm().format(dateTime); // e.g., Jun 7, 2025 1:12 AM
  }
}