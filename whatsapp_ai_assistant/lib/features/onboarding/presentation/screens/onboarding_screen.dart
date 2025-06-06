// lib/features/onboarding/presentation/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ai_assistant/core/utils/app_logger.dart';
import 'package:whatsapp_ai_assistant/core/utils/permission_utils.dart';
import 'package:whatsapp_ai_assistant/features/chat_management/presentation/screens/chat_management_screen.dart';

// Provider to manage the current step of onboarding
final onboardingStepProvider = StateProvider<int>((ref) => 0);

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentStep = ref.watch(onboardingStepProvider);
    final Logger logger = AppLogger.instance;

    Future<void> _checkAndNavigate() async {
      logger.i('Checking all permissions after onboarding steps...');
      final bool notificationAccess = await PermissionUtils.isNotificationListenerEnabled();
      final bool accessibilityAccess = await PermissionUtils.isAccessibilityServiceEnabled();

      if (notificationAccess && accessibilityAccess) {
        logger.i('All required permissions granted. Navigating to ChatManagementScreen.');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ChatManagementScreen()),
        );
      } else {
        logger.w('Not all required permissions granted. User needs to enable them.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please grant all required permissions to proceed.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to AI Assistant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: PageView(
                onPageChanged: (index) {
                  ref.read(onboardingStepProvider.notifier).state = index;
                },
                controller: PageController(initialPage: currentStep),
                children: [
                  _OnboardingPage(
                    title: 'Step 1: Grant Notification Access',
                    description:
                        'Allow WhatsApp AI Assistant to read incoming WhatsApp messages by enabling Notification Access. This is crucial for detecting messages and providing AI responses.',
                    icon: Icons.notifications_active,
                    buttonText: 'Grant Notification Access',
                    onButtonPressed: () async {
                      logger.d('Opening notification settings...');
                      await PermissionUtils.openNotificationListenerSettings();
                      // After user returns, re-check state
                      await Future.delayed(const Duration(seconds: 1)); // Give user time to grant
                      if (await PermissionUtils.isNotificationListenerEnabled()) {
                        logger.i('Notification access granted. Moving to next step.');
                        ref.read(onboardingStepProvider.notifier).state = 1;
                      } else {
                        logger.w('Notification access still not granted.');
                      }
                    },
                    isGranted: ref.watch(notificationListenerEnabledProvider).value ?? false,
                  ),
                  _OnboardingPage(
                    title: 'Step 2: Enable Accessibility Service',
                    description:
                        'To automatically reply to messages, WhatsApp AI Assistant needs Accessibility Service permission. This allows it to simulate typing and sending messages in WhatsApp.',
                    icon: Icons.accessibility_new,
                    buttonText: 'Enable Accessibility Service',
                    onButtonPressed: () async {
                      logger.d('Opening accessibility settings...');
                      await PermissionUtils.openAccessibilityServiceSettings();
                      // After user returns, re-check state
                      await Future.delayed(const Duration(seconds: 1)); // Give user time to grant
                      if (await PermissionUtils.isAccessibilityServiceEnabled()) {
                        logger.i('Accessibility service granted. Moving to next step.');
                        ref.read(onboardingStepProvider.notifier).state = 2;
                      } else {
                        logger.w('Accessibility service still not granted.');
                      }
                    },
                    isGranted: ref.watch(accessibilityServiceEnabledProvider).value ?? false,
                  ),
                  _OnboardingPage(
                    title: 'Setup Complete!',
                    description:
                        'You\'re all set! WhatsApp AI Assistant is now configured. You can start managing monitored chats and AI personalities.',
                    icon: Icons.check_circle_outline,
                    buttonText: 'Go to Dashboard',
                    onButtonPressed: () async {
                      await _checkAndNavigate();
                    },
                    isGranted: ref.watch(notificationListenerEnabledProvider).value ?? false &&
                               ref.watch(accessibilityServiceEnabledProvider).value ?? false,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: currentStep == index ? 12.0 : 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    color: currentStep == index ? Theme.of(context).primaryColor : Colors.grey,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Providers to watch permission states live
final notificationListenerEnabledProvider = StreamProvider.autoDispose<bool>((ref) async* {
  while (true) {
    yield await PermissionUtils.isNotificationListenerEnabled();
    await Future.delayed(const Duration(seconds: 2)); // Check every 2 seconds
  }
});

final accessibilityServiceEnabledProvider = StreamProvider.autoDispose<bool>((ref) async* {
  while (true) {
    yield await PermissionUtils.isAccessibilityServiceEnabled();
    await Future.delayed(const Duration(seconds: 2)); // Check every 2 seconds
  }
});


class _OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final bool isGranted;

  const _OnboardingPage({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.buttonText,
    required this.onButtonPressed,
    required this.isGranted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 100,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 30),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          description,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 40),
        ElevatedButton.icon(
          onPressed: isGranted ? null : onButtonPressed, // Disable button if already granted
          icon: isGranted ? const Icon(Icons.check_circle_outline) : Icon(Icons.settings),
          label: Text(isGranted ? 'Granted' : buttonText),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }
}