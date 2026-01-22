import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Last Updated: January 2026',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _buildSection(
              '1. Introduction',
              'Welcome to "100 Chinese Travel Phrases" ("we," "our," or "us"). We are committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you use our mobile application.',
            ),
            _buildSection(
              '2. Information Collection',
              'We do not collect any personal identifiable information (PII) such as your name, email address, or phone number. The app operates primarily offline and stores your progress locally on your device.',
            ),
            _buildSection(
              '3. Microphone Usage',
              'Our app requires access to your device\'s microphone to provide the "Speaking/Shadowing" feature. This allows you to practice pronunciation. \n\nIMPORTANT: All audio processing for speech recognition is performed locally on your device (using iOS Speech framework) or via standard system APIs. We do not record, store, or upload your voice recordings to any external servers.',
            ),
            _buildSection(
              '4. In-App Purchases',
              'We use RevenueCat to manage in-app purchases. When you make a purchase, RevenueCat may collect anonymous data regarding the transaction to validate your receipt and unlock Pro features. We do not have access to your credit card or payment information, which is processed securely by Apple via the App Store.',
            ),
            _buildSection(
              '5. Third-Party Services',
              'We may use third-party services (like RevenueCat) that may collect information used to identify your device for analytics and purchase validation purposes. Please refer to their privacy policies for more details.',
            ),
            _buildSection(
              '6. Children\'s Privacy',
              'Our application does not knowingly collect or solicit personal information from anyone under the age of 13. If you are a parent or guardian and believe we have collected information from your child, please contact us.',
            ),
            _buildSection(
              '7. Changes to This Policy',
              'We may update our Privacy Policy from time to time. You are advised to review this page periodically for any changes. Changes are effective immediately after they are posted on this page.',
            ),
            _buildSection(
              '8. Contact Us',
              'If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us.',
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
