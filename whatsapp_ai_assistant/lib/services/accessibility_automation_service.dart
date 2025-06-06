import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

final Logger _logger = Logger();

class AccessibilityAutomationService {
  static const MethodChannel _platform = MethodChannel('com.example.whatsapp_ai_assistant/accessibility');

  AccessibilityAutomationService._(); // Private constructor for utility class

  // Make methods static if they don't depend on instance state
  static Future<void> sendMessageViaAccessibility(String message, String contact) async {
    try {
      _logger.d('Attempting to send message via accessibility: "$message" to "$contact"');
      await _platform.invokeMethod('sendMessage', {'message': message, 'contact': contact});
      _logger.i('Message sent via accessibility.');
    } on PlatformException catch (e) {
      _logger.e('Failed to send message via accessibility: ${e.message}', error: e);
      throw Exception('Failed to send message via accessibility: ${e.message}');
    }
  }

  static Future<void> openWhatsAppChat(String contact) async {
    try {
      _logger.d('Attempting to open WhatsApp chat for: "$contact"');
      await _platform.invokeMethod('openWhatsAppChat', {'contact': contact});
      _logger.i('WhatsApp chat opened.');
    } on PlatformException catch (e) {
      _logger.e('Failed to open WhatsApp chat: ${e.message}', error: e);
      throw Exception('Failed to open WhatsApp chat: ${e.message}');
    }
  }

  // Add other accessibility methods as needed
}