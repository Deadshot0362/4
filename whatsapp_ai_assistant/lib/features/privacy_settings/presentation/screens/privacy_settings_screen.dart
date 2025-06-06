// lib/features/privacy_settings/presentation/screens/privacy_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ai_assistant/features/privacy_settings/domain/entities/data_retention_period.dart';
import 'package:whatsapp_ai_assistant/features/privacy_settings/presentation/providers/privacy_settings_providers.dart';
import 'package:whatsapp_ai_assistant/ui/shared_widgets/custom_app_bar.dart';

class PrivacySettingsScreen extends ConsumerWidget {
  const PrivacySettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRetentionPeriod = ref.watch(dataRetentionPeriodProvider);
    final privacySettingsController = ref.watch(privacySettingsControllerProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Privacy & Security',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Data Retention Settings', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...DataRetentionPeriod.values.map((period) {
              return RadioListTile<DataRetentionPeriod>(
                title: Text('Keep data for ${period.toDisplayString()}'),
                value: period,
                groupValue: selectedRetentionPeriod,
                onChanged: (DataRetentionPeriod? value) {
                  if (value != null) {
                    privacySettingsController.selectDataRetentionPeriod(value);
                  }
                },
              );
            }).toList(),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Trigger manual clear history
                privacySettingsController.clearAllHistory();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Conversation history cleared!')));
              },
              icon: const Icon(Icons.delete_forever),
              label: const Text('Clear All Conversation History'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 30),
            Text('Privacy Policy', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            // TODO: Link to or display the privacy policy text
            ElevatedButton.icon(
              onPressed: () {
                // Implement displaying Privacy Policy (e.g., in a new screen or WebView)
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Privacy Policy'),
                    content: const SingleChildScrollView(
                      child: Text(_privacyPolicyContent), // Use the string below
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.policy),
              label: const Text('View Privacy Policy'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            ),
            const SizedBox(height: 20),
            Text('Terms of Service', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            // TODO: Link to or display the terms of service text
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Terms of Service'),
                    content: const SingleChildScrollView(
                      child: Text(_termsOfServiceContent), // Use the string below
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.description),
              label: const Text('View Terms of Service'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            ),
          ],
        ),
      ),
    );
  }
}

// Example Privacy Policy Content (Replace with your actual policy)
const String _privacyPolicyContent = '''
## WhatsApp AI Assistant Privacy Policy

This Privacy Policy describes how WhatsApp AI Assistant ("the App") collects, uses, and discloses information when you use our mobile application.

**1. Data Collection and Use**
The App requires certain permissions to function, including:
- **Notification Access**: To read incoming WhatsApp messages in real-time. This data is processed locally on your device to generate AI responses.
- **Accessibility Service**: To simulate user input for sending AI-generated replies within WhatsApp.

**No Personal Data is Transmitted Off Your Device**: All WhatsApp message content and AI-generated responses are processed and stored *only* on your local device's database. We do not transmit this data to our servers or any third-party servers.

**AI API Integration**: When using AI features, a portion of your conversation (recent messages and the new incoming message) is sent to the OpenAI API for processing. Your OpenAI API key is stored securely using Android's EncryptedSharedPreferences on your device. We do not store or have access to your OpenAI API key.

**2. Data Storage and Security**
- **Local Storage**: Conversation history (messages, timestamps, AI responses) is stored securely on your device using an encrypted SQLite database (Drift with potential SQLCipher integration).
- **Secure Credentials**: Sensitive information, like your OpenAI API key, is stored using Android's EncryptedSharedPreferences.
- **Encryption**: All stored data on your device is encrypted to protect your privacy.

**3. Data Retention**
You have control over your data retention settings. You can:
- Manually clear all conversation history.
- Set automatic deletion periods (e.g., 7, 30, or 90 days). Data older than the selected period will be automatically deleted from your device.

**4. Third-Party Services**
- **OpenAI**: The App integrates with the OpenAI API for AI capabilities. Your usage of the OpenAI API is subject to OpenAI's Terms of Service and Privacy Policy. Please review them at [https://openai.com/privacy/](https://openai.com/privacy/).
- We do not integrate with any other third-party analytics, advertising, or data collection services.

**5. User Controls**
- **Chat Monitoring**: You can selectively choose which WhatsApp chats the AI monitors and responds to.
- **AI Personalities**: You can customize AI personalities and adjust parameters.
- **Data Deletion**: You have full control over deleting your locally stored data.

**6. Changes to This Privacy Policy**
We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy within the App.

**7. Contact Us**
If you have any questions about this Privacy Policy, please contact us at [your.email@example.com].

Last updated: June 7, 2025
''';

// Example Terms of Service Content (Replace with your actual terms)
const String _termsOfServiceContent = '''
## WhatsApp AI Assistant Terms of Service

**1. Acceptance of Terms**
By accessing or using the WhatsApp AI Assistant mobile application ("the App"), you agree to be bound by these Terms of Service. If you do not agree to these terms, do not use the App.

**2. Use of the App**
- **Purpose**: The App is designed to provide AI-powered assistance for your WhatsApp messaging. It is intended for personal, non-commercial use only.
- **Permissions**: The App requires specific Android permissions (Notification Access, Accessibility Service) to function. You are responsible for understanding and granting these permissions.
- **Unofficial Integration**: The App integrates with WhatsApp using unofficial Android system services. This integration is not endorsed or supported by WhatsApp/Meta. The functionality may be unstable, break, or cease to work with WhatsApp updates.
- **Your Responsibility**: You are solely responsible for all content sent through the App and for ensuring your use complies with WhatsApp's Terms of Service and all applicable laws.

**3. AI Services and Third-Party API**
- The App utilizes third-party AI models (e.g., OpenAI GPT) via their respective APIs. Your use of the AI features is subject to the terms and policies of the AI service provider (e.g., OpenAI's Terms of Use).
- You are responsible for obtaining and managing your own AI API keys. The App does not provide these keys.
- AI responses are generated by automated models and may not always be accurate, appropriate, or free of bias. You should exercise your own judgment when relying on AI-generated content.

**4. Data Privacy and Security**
- As outlined in our Privacy Policy, all your WhatsApp message data and AI-generated responses are processed and stored locally on your device. We do not transmit or store your personal data on our servers.
- While we implement security measures, no system is entirely foolproof. We cannot guarantee absolute security of your device data.

**5. Disclaimers**
- The App is provided "as is" without warranties of any kind. We do not warrant that the App will be uninterrupted, error-free, or free of harmful components.
- We are not responsible for any direct, indirect, incidental, or consequential damages resulting from your use or inability to use the App, including any issues arising from the unofficial WhatsApp integration.

**6. Limitation of Liability**
To the maximum extent permitted by applicable law, in no event shall WhatsApp AI Assistant or its developers be liable for any damages arising out of or in connection with your use of the App.

**7. Changes to Terms**
We reserve the right to modify these Terms of Service at any time. We will notify you of significant changes by updating the "Last updated" date. Your continued use of the App after such modifications constitutes your acceptance of the new Terms.

**8. Governing Law**
These Terms shall be governed by and construed in accordance with the laws of [Your Country/State, e.g., India], without regard to its conflict of law provisions.

**9. Contact Information**
For any questions regarding these Terms, please contact us at [your.email@example.com].

Last updated: June 7, 2025
''';