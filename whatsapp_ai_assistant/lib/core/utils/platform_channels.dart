// lib/core/utils/platform_channels.dart
import 'package:flutter/services.dart';
import 'package:whatsapp_ai_assistant/config/app_constants.dart';
import 'package:whatsapp_ai_assistant/core/utils/app_logger.dart';

class PlatformChannels {
  static final MethodChannel _notificationMethodChannel = MethodChannel(AppConstants.notificationChannel);
  static final EventChannel _notificationEventChannel = EventChannel(AppConstants.notificationChannel);
  static final MethodChannel _accessibilityMethodChannel = MethodChannel(AppConstants.accessibilityChannel);
  static final Logger _logger = AppLogger.instance;

  // --- Notification Listener Service ---

  /// Starts listening for WhatsApp notifications.
  static Future<void> startNotificationListener() async {
    try {
      await _notificationMethodChannel.invokeMethod('startNotificationListener');
      _logger.i('Notification listener started via platform channel.');
    } on PlatformException catch (e) {
      _logger.e('Failed to start notification listener: ${e.message}');
    }
  }

  /// Stops listening for WhatsApp notifications.
  static Future<void> stopNotificationListener() async {
    try {
      await _notificationMethodChannel.invokeMethod('stopNotificationListener');
      _logger.i('Notification listener stopped via platform channel.');
    } on PlatformException catch (e) {
      _logger.e('Failed to stop notification listener: ${e.message}');
    }
  }

  /// Provides a stream of incoming WhatsApp messages from the native listener.
  Stream<Map<dynamic, dynamic>> get incomingWhatsAppMessages {
    return _notificationEventChannel.receiveBroadcastStream().map((event) {
      _logger.d('Received event from NotificationListener: $event');
      if (event is Map) {
        return event as Map<dynamic, dynamic>;
      }
      return <dynamic, dynamic>{};
    }).handleError((error) {
      _logger.e('Error in NotificationListener stream: $error');
      if (error is PlatformException) {
        _logger.e('PlatformException in NotificationListener stream: ${error.message}');
      }
    });
  }

  // --- Accessibility Service ---

  /// Sends a message using the Accessibility Service.
  /// chatName: The name of the WhatsApp chat (e.g., contact name or group name).
  /// message: The message text to send.
  static Future<bool> sendMessageViaAccessibility(String chatName, String message) async {
    try {
      final bool? success = await _accessibilityMethodChannel.invokeMethod('sendMessage', {
        'chatName': chatName,
        'message': message,
      });
      _logger.i('Attempted to send message via Accessibility Service to "$chatName": $message, Success: $success');
      return success ?? false;
    } on PlatformException catch (e) {
      _logger.e('Failed to send message via Accessibility Service: ${e.message}');
      return false;
    }
  }
  
  /// Opens a specific WhatsApp chat using the Accessibility Service.
  static Future<bool> openWhatsAppChat(String chatName) async {
    try {
      final bool? success = await _accessibilityMethodChannel.invokeMethod('openWhatsAppChat', {
        'chatName': chatName,
      });
      _logger.i('Attempted to open WhatsApp chat "$chatName", Success: $success');
      return success ?? false;
    } on PlatformException catch (e) {
      _logger.e('Failed to open WhatsApp chat via Accessibility Service: ${e.message}');
      return false;
    }
  }
}