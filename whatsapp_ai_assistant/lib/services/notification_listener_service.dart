// lib/services/notification_listener_service.dart
import 'package:whatsapp_ai_assistant/core/utils/app_logger.dart';
import 'package:whatsapp_ai_assistant/core/utils/platform_channels.dart';

/// Provides an interface for Flutter to control and receive events from the native NotificationListenerService.
class NotificationListenerService {
  final PlatformChannels _platformChannels = PlatformChannels();
  final Logger _logger = AppLogger.instance;

  /// Starts the native NotificationListenerService.
  Future<void> startListening() async {
    _logger.i('Attempting to start native NotificationListenerService...');
    await _platformChannels.startNotificationListener();
  }

  /// Stops the native NotificationListenerService.
  Future<void> stopListening() async {
    _logger.i('Attempting to stop native NotificationListenerService...');
    await _platformChannels.stopNotificationListener();
  }

  /// Returns a stream of parsed WhatsApp messages from the native service.
  Stream<Map<dynamic, dynamic>> get whatsAppMessagesStream {
    return _platformChannels.incomingWhatsAppMessages;
  }
}