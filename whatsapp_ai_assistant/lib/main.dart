// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ai_assistant/core/utils/app_logger.dart';
import 'package:whatsapp_ai_assistant/data/local/app_database.dart';
import 'package:whatsapp_ai_assistant/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:whatsapp_ai_assistant/ui/themes/app_theme.dart';
import 'package:logger/logger.dart';
import 'package:whatsapp_ai_assistant/features/chat_management/presentation/screens/chat_management_screen.dart';
import 'package:whatsapp_ai_assistant/services/background_messaging_service.dart';

// Import the provider from the database file instead of redefining it
// final appDatabaseProvider = Provider<AppDatabase>((ref) {
//   return AppDatabase();
// });

// Global logger instance
final loggerProvider = Provider<Logger>((ref) => AppLogger.instance);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize logger
  AppLogger.init();
  final logger = AppLogger.instance;

  logger.i('App starting...');

  // Initialize and start background messaging service
  final backgroundService = BackgroundMessagingService();
  await backgroundService.init();
  backgroundService.start();

  logger.i('BackgroundMessagingService initialized and started.');

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if onboarding is completed. For simplicity, we'll navigate to chat_management_screen
    // if onboarding is complete. In a real app, this would be determined by a persisted flag.
    final bool onboardingCompleted = false; // TODO: Implement actual onboarding check from settings/storage

    return MaterialApp(
      title: 'WhatsApp AI Assistant',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Or ThemeMode.light/dark based on user preference
      home: onboardingCompleted ? const ChatManagementScreen() : const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}