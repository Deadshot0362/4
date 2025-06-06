// lib/core/utils/app_logger.dart
import 'package:logger/logger.dart';

class AppLogger {
  static late Logger _logger;

  static void init() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2, // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        lineLength: 120, // width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        printTime: true, // Should each log print a timestamp
      ),
    );
  }

  static Logger get instance {
    if (_logger == null) {
      init(); // Ensure initialization if accessed before main.
    }
    return _logger;
  }
}